Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE2B268FED;
	Tue,  8 Apr 2025 10:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109722; cv=none; b=GDtGnBO9y+uSjQlB+ZZX7STCahaN1xeI9xB9902/xUMR4CQTuh1M035KAkSgOzbpF9FtZO2IF0uyRYh6LtbnBoaB7c+ZPRUAAEKD453Drp66GryOX9uuNHDzy1RDm/31dQMvMaaog59kcRPPWD+eTz3l3lEBs1m//B5yp7RrLzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109722; c=relaxed/simple;
	bh=75A7YswmAk2Iiq72FrnqaU9XSBmKBsVKP25G5XLsOvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ScZfbkgX4qONRD8i82AxwGxwlu4Zn9CSWMDRAX8TJm97OpERIEwLadjwg9Kqv85SksA6XIsUXJV7E7pK1sEWX4bpupbsPe5fbIghywm7FwfFfYTALDLW0p/xYWFkT2GcHLhFb3cw8t9CU9uaBO65AHCaq9VTJnkA+wpOJcsBCeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrBK6ZxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrBK6ZxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FC7C4CEE5;
	Tue,  8 Apr 2025 10:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109721;
	bh=75A7YswmAk2Iiq72FrnqaU9XSBmKBsVKP25G5XLsOvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VrBK6ZxIoDtRc4dYooe5HGYm2bGMY+2a3pHL+epKzm/T/YHZJvTcsAP5fXkgl5Vwq
	 syhKaBqDgQjcBTLCkYg0Zen3HJcporXpyi+/ZxEMB4PPwccNzsDQ9TdtvXE6/YD4Vd
	 SRHh8Ckf5xFe4tCP24eDgpyujJprrGXyVyHtJ/Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brahmajit Das <brahmajit.xyz@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/227] vboxsf: fix building with GCC 15
Date: Tue,  8 Apr 2025 12:46:46 +0200
Message-ID: <20250408104821.245190694@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f11bcbac77278..4a77a5a3109ee 100644
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



