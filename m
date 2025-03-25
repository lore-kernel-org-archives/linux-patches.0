Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860B825745C;
	Tue, 25 Mar 2025 12:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905591; cv=none; b=mUOFVKz/oeC1wWJ3Q4uO0VfzsZj3QK8yB9sVEVckiUoY7SdPi7OoT8IGioMDYbzV2kJC4iDLHm/7HuL6jUrMVW5sSbbrpI32ecI1ctU+D8y23CXM9u0dzWKFHnvijNsksp9CMsQtSt0LDqKsWdmL1o/6318XI12J2iqRPG0nxCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905591; c=relaxed/simple;
	bh=dHFqGZB/o+zvBVM1Np0QC6tdfZwG1YyL1xBe94SUimw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G0VFtcE3qZzIBnmhpIehWcsI1m5PXJbWK8CsECPGnKHTR8tnlugtuUUem0OrjUdNnPJATFNMA5waoqZgnmWf5zVpB6kWIJ86k6RUy8rKx8513txE9w7/Kl5H2ku7A2WnTO6/biflbC10M/cCAkcRe27dqjbLRKeCLEwYwRGiaUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQzwY3qz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQzwY3qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0ADC4CEF1;
	Tue, 25 Mar 2025 12:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905591;
	bh=dHFqGZB/o+zvBVM1Np0QC6tdfZwG1YyL1xBe94SUimw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQzwY3qz4TS6TICigPiWMF8TwDoe7H4cyWADN6zecZ/I//8X2d8SMQNanA7YFHSLS
	 o6YV4fh+3VGmrAFbGhGXrOktD9Decqu+oQuyvFXAF+SLMvaupYrZNaZOwM9uFDc8ac
	 iZ4IbroeBhrnIy0wIyb5IW0AE74Rk8SRexEj/yFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brahmajit Das <brahmajit.xyz@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/198] vboxsf: fix building with GCC 15
Date: Tue, 25 Mar 2025 08:20:02 -0400
Message-ID: <20250325122157.693448563@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brahmajit Das <brahmajit.xyz@gmail.com>

[ Upstream commit 4e7487245abcbc5a1a1aea54e4d3b33c53804bda ]

Building with GCC 15 results in build error
fs/vboxsf/super.c:24:54: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
   24 | static const unsigned char VBSF_MOUNT_SIGNATURE[4] = "\000\377\376\375";
      |                                                      ^~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Due to GCC having enabled -Werror=unterminated-string-initialization[0]
by default. Separately initializing each array element of
VBSF_MOUNT_SIGNATURE to ensure NUL termination, thus satisfying GCC 15
and fixing the build error.

[0]: https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wno-unterminated-string-initialization

Signed-off-by: Brahmajit Das <brahmajit.xyz@gmail.com>
Link: https://lore.kernel.org/r/20250121162648.1408743-1-brahmajit.xyz@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/vboxsf/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/vboxsf/super.c b/fs/vboxsf/super.c
index 74952e58cca06..48f33d4994dc8 100644
--- a/fs/vboxsf/super.c
+++ b/fs/vboxsf/super.c
@@ -21,7 +21,8 @@
 
 #define VBOXSF_SUPER_MAGIC 0x786f4256 /* 'VBox' little endian */
 
-static const unsigned char VBSF_MOUNT_SIGNATURE[4] = "\000\377\376\375";
+static const unsigned char VBSF_MOUNT_SIGNATURE[4] = { '\000', '\377', '\376',
+						       '\375' };
 
 static int follow_symlinks;
 module_param(follow_symlinks, int, 0444);
-- 
2.39.5



