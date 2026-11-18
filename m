Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021875;
	b=X0y5Kxf7Y5i0WAtTlwx50nb/qC9rX826Di0yEssbFleLFymDrfX6UZiTwBTs8r9ZYJmC
	 syat7cULWBLoDE4Nt0inm7NF5ES/b2193JZ9aC9wqXTyTnaD8hXAvqpqFMHLoSygrIEfv
	 0vCmLusYGv0V8Ihi5v4o1xKA+OTHBzT0uS1kE45K2qPzxqzAUo3IPKZdmZtMazINgZsSR
	 2wYqTcTsyEFH/YHkVJHGmENTpDoBKn6UUaz8DlZph0DXaL7chIoygfdRBIBTGqDIP08fc
	 GKPl2oXR2h9Kast/EchBG6cffDjF6MDWTtGGDcmZkUcWNRMWGIuAR/zmHwdQijNHbGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b2rAEDv9nxRiNFSG6T/4y70EebwRNj7SGwQTtpgjiGo=;
	b=jWhMOFKSYAhzjXL6SH4LvC2xQSO1cS/5Euns4WjXwfLik2m4SLHzvd0XBH8TsWMl74fr
	 1lpCwEXrHlZRmb75Oj3svR/QLBRiDdD4V3EV/DLmW2vG7I2j29bjs+qesNLNDBjFD81aV
	 li9zEIAXgBZFAX9fvob1Do/vLo2mJPt2TiCMpe5GeNzcKeMGMMrt/3+wtSYK89JBNLhr0
	 wXbsb+3lk6FH8d6DlBvpiXtGOuAzNB0/CvqsN8BJd8KpeEoUYW3b41hUdVltQx3/jzd85
	 fYSp1n768xksgd1Su/6xoNvqJrpFw2ao4BUdi6b7NGj1cx43+QE3tlbB2NY1nYnxS2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7oiIyoP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79995606A320;
	Wed, 18 Nov 2026 17:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f7oiIyoP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4881F000C6;
	Wed, 18 Nov 2026 17:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021875;
	bh=b2rAEDv9nxRiNFSG6T/4y70EebwRNj7SGwQTtpgjiGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7oiIyoP4zttXLjlGuVsaNxnN/YPoOm2//vC5ahCHepwDv0gcudYXgFVbqIEfyWcw
	 ezh3kIVHvhNsIqWYPFP+S/fiCZORter4uAYa/OEkp1UlGyulf+/wImmqoXyTMpWxKL
	 SpIpEl2aOrsWhrJZHqyzz+5gKZUvT9VfQ+HPtfiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gao Xiang (Docker)" <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2463/2651] erofs: drop unnecessary .read_folio() checks for file-backed mounts
Date: Wed, 18 Nov 2026 16:01:43 +0100
Message-ID: <20261118150413.707995129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <xiang@kernel.org>

[ Upstream commit 209108a5456171ab430e25b54b2dfe083455bfb6 ]

Since currently dedicated EROFS-owned meta inodes are used for
file-backed mounts, .read_folio() checks are now redundant.

As a result, EROFS file-back mounts can now apply to tmpfs too.

Fixes: e587a984d332 ("erofs: use dedicated meta inodes for file-backed mounts")
Signed-off-by: Gao Xiang (Docker) <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 16fa3b853f1b6..254b32f77a42a 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -850,8 +850,7 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 			errorfc(fc, "source fd option not supported");
 			return -EINVAL;
 		}
-		if (!S_ISREG(file_inode(sbi->dif0.file)->i_mode) ||
-		    !sbi->dif0.file->f_mapping->a_ops->read_folio) {
+		if (!S_ISREG(file_inode(sbi->dif0.file)->i_mode)) {
 			errorfc(fc, "source is unsupported");
 			return -EINVAL;
 		}
@@ -871,8 +870,7 @@ static int erofs_fc_get_tree(struct fs_context *fc)
 			return PTR_ERR(file);
 		sbi->dif0.file = file;
 
-		if (S_ISREG(file_inode(sbi->dif0.file)->i_mode) &&
-		    sbi->dif0.file->f_mapping->a_ops->read_folio)
+		if (S_ISREG(file_inode(sbi->dif0.file)->i_mode))
 			return erofs_file_get_tree(fc);
 	}
 	return ret;
-- 
2.53.0



