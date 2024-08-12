Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF00134AC;
	Mon, 12 Aug 2024 16:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479794; cv=none; b=YJQImVca/q5FnFpaDRVSje5U/SuRbnpLoSrPSVtHWhtHBN/CubIyTUv4xfRebS01ffQU3lCd+nBTQDVsfuZ+Ytgr2xMxvcUIoTbW8+w24/IdwnDVBrMRal2lo+s3TL5CnlJ8+FpmlTmQkQrQaeETgHUyf1dq0Li/ugKEXPNN33A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479794; c=relaxed/simple;
	bh=H4owZVqZIBjuv2yzmAFXhFc6FsHvue5GazB9Dtbv7go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjfs/01xLKsT7SM4VO51EwGq4LIESgC7uWFKnV7MCNCB2bHwTOLv8witIVhAz5ip/KAqstZjCdQ6/KqEo9NKaNNesVO8hzwPaLevOIwIDqaePIzVWqhJB46BM9ya9Nlsi31cQIH4gmwkFCAfqIeVxc4DvbA6hpr6ZeEYs4ridco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oijUIn05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oijUIn05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EB3C32782;
	Mon, 12 Aug 2024 16:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479794;
	bh=H4owZVqZIBjuv2yzmAFXhFc6FsHvue5GazB9Dtbv7go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oijUIn05ZyXPMmjWF03stEDmZbdJo0dwqpPku4SeQByAnMtpkQv3T4JsNB2iKKRK8
	 XIkMtd+J5LJhJrgaSL9HW7f0gcVsAN6II0a4YHRJ3gcwfLxeWAgRcFaOrTRHe17dAO
	 HzTE9gr/OIi7NZO78F6mXxVmNSExg0xVaLiNvDFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 166/189] drm/radeon: Remove __counted_by from StateArray.states[]
Date: Mon, 12 Aug 2024 18:03:42 +0200
Message-ID: <20240812160138.535854504@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bill Wendling <morbo@google.com>

commit 2bac084468847cfe5bbc7166082b2a208514bb1c upstream.

Work for __counted_by on generic pointers in structures (not just
flexible array members) has started landing in Clang 19 (current tip of
tree). During the development of this feature, a restriction was added
to __counted_by to prevent the flexible array member's element type from
including a flexible array member itself such as:

  struct foo {
    int count;
    char buf[];
  };

  struct bar {
    int count;
    struct foo data[] __counted_by(count);
  };

because the size of data cannot be calculated with the standard array
size formula:

  sizeof(struct foo) * count

This restriction was downgraded to a warning but due to CONFIG_WERROR,
it can still break the build. The application of __counted_by on the
states member of 'struct _StateArray' triggers this restriction,
resulting in:

  drivers/gpu/drm/radeon/pptable.h:442:5: error: 'counted_by' should not be applied to an array with element of unknown size because 'ATOM_PPLIB_STATE_V2' (aka 'struct _ATOM_PPLIB_STATE_V2') is a struct type with a flexible array member. This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
    442 |     ATOM_PPLIB_STATE_V2 states[] __counted_by(ucNumEntries);
        |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Remove this use of __counted_by to fix the warning/error. However,
rather than remove it altogether, leave it commented, as it may be
possible to support this in future compiler releases.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2028
Fixes: efade6fe50e7 ("drm/radeon: silence UBSAN warning (v3)")
Signed-off-by: Bill Wendling <morbo@google.com>
Co-developed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/pptable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/pptable.h
+++ b/drivers/gpu/drm/radeon/pptable.h
@@ -439,7 +439,7 @@ typedef struct _StateArray{
     //how many states we have 
     UCHAR ucNumEntries;
     
-    ATOM_PPLIB_STATE_V2 states[] __counted_by(ucNumEntries);
+    ATOM_PPLIB_STATE_V2 states[] /* __counted_by(ucNumEntries) */;
 }StateArray;
 
 


