Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F070F3F7887;
	Tue, 31 Mar 2026 16:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974838; cv=none; b=GjL+iwLmqZl7jIEpwJeUxK8njbilSLX5cvJDz+TDLPKnXpdgFbuBGc6m/JOdIehPxVXCGlzUC90//dcGxJkr9Rfc1KyEMmWwEuBQwBENVVCdiv8F06VINJJ42yGRrsQFP7qTRTrhbS1nBkiZWawbwSOfT26UxJAYrEGAXbAEuIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974838; c=relaxed/simple;
	bh=tl9+kGh8Kb3nuRai4cWEOe2aOKMP6nDICZaq9DuHSRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THbZPMpzSEbAyOVOQz/MmafpCZ8+i6rv/jO1EnXefEfrHPOOA6gKuO048EJa51mzcMUVoKS4DDY7Poq5cYGXuv0aoEcSgVqu6NvE8rMp6Ru6hD10IFIejEUbmgOvERfo1J8CQIECaOe58BAuxTUdlw/mfIp1mfvBGY9DAMr2sG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Z2mCBwK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Z2mCBwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890F4C19423;
	Tue, 31 Mar 2026 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974837;
	bh=tl9+kGh8Kb3nuRai4cWEOe2aOKMP6nDICZaq9DuHSRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Z2mCBwKpzv1rFhIRptdCtC8g2cPYejPhWk8hUpiRKv65zt6WoU2yyNLzWqpkRQDw
	 6m5z9GETZWR40mApa4dfpV8TVRkGRbkOKblQNTtJO3PfTgqCe3qWBNbpdx0vNt/6lH
	 rrDo3xd/dAvKDJdTBMi6AhQMcKig1aNFsIznJXbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HONG Yifan <elsk@google.com>,
	Carlos Llamas <cmllamas@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 064/342] objtool: Use HOSTCFLAGS for HAVE_XXHASH test
Date: Tue, 31 Mar 2026 18:18:17 +0200
Message-ID: <20260331161801.250223651@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HONG Yifan <elsk@google.com>

[ Upstream commit 32234049107d012703d50547e815f198f147968b ]

Previously, HAVE_XXHASH is tested by invoking HOSTCC without HOSTCFLAGS.

Consider the following scenario:

- The host machine has libxxhash installed
- We build the kernel with HOSTCFLAGS containing a --sysroot that does
  not have xxhash.h (for hermetic builds)

In this case, HAVE_XXHASH is set to y, but when it builds objtool with
HOSTCFLAGS, because the --sysroot does not contain xxhash.h, the
following error is raised:

<...>/common/tools/objtool/include/objtool/checksum_types.h:12:10: fatal error: 'xxhash.h' file not found
   12 | #include <xxhash.h>
      |          ^~~~~~~~~~

To resolve the error, we test HAVE_XXHASH by invoking HOSTCC with
HOSTCFLAGS.

Signed-off-by: HONG Yifan <elsk@google.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260303010340.306164-1-elsk@google.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 76bcd4e85de34..b71d1886022e9 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -13,7 +13,7 @@ endif
 
 ifeq ($(ARCH_HAS_KLP),y)
 	HAVE_XXHASH = $(shell printf "$(pound)include <xxhash.h>\nXXH3_state_t *state;int main() {}" | \
-		      $(HOSTCC) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || echo n)
+		      $(HOSTCC) $(HOSTCFLAGS) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || echo n)
 	ifeq ($(HAVE_XXHASH),y)
 		BUILD_KLP	 := y
 		LIBXXHASH_CFLAGS := $(shell $(HOSTPKG_CONFIG) libxxhash --cflags 2>/dev/null) \
-- 
2.51.0



