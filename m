Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209230;
	b=fMOtjZU1treSeA8ugokp2wbu9fR35SNJMa5MYgM2xlQ0bYUyAEUrjO8X7iQFjIDpcMho
	 qTvmJOqm0N+TDhw+4ZoRO589/WXy6Ww5nyP7Gj5QNFFD9PcoYi454AYBG/42ZER3QgDK6
	 TbdJhzLV6sotkZUZGfYWkzP4/4fXrlUc63lGDf4M6MH25i3ar10/abwcifQ/JdfhJC6Bb
	 Qs8kCxX5TKChisYFDM/HVUzA/NAGiJmuWgwfqvO4Izm0FpBD+tzPNN3Wt3dmTVvL7FnFB
	 ynlpgaHyC58+a7F5pQ95asiC6vFl3giVuYLX7iE8LeogFUfi9Lp84NUUo9TdcgtQgcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/CIvDNF2sdj5hrNCHcnMNkNPpzWKhxByp//+SN286XM=;
	b=5iTtjPfABYXsR2RYwaG68z/UnpQE1+ftIed92sbDM1+zYYYtk54dcnxi6TZjH0bXUFp1
	 p+r+EnPB0+s+eqpEMjYBivNjKvUioPe35XYNhwjbQT5pmiCX66l+5++yNDNqmZzuoUwUy
	 6tDpiamw669NxO35mn0pUYO0EQVZA+nryqP7O7z7HbO3ClKJX23LFiqbGPdaNMCdYY6BI
	 zmbMJqRRHEj4DqC/bD8ivVlpHaCUzs1HnvOdyjzS+Lhj8DuMPkzpl9q54lwrlwJNO1U7w
	 RFx5Nb+kNav6jRViHLpukCTzeprXJ6c070W66ZKC9naPPjPIOL+qAXsTlGo1YF//MoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1Z4NOQM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B74606A31C;
	Wed, 28 Oct 2026 17:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1Z4NOQM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDBD1F01825;
	Wed, 28 Oct 2026 17:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209230;
	bh=/CIvDNF2sdj5hrNCHcnMNkNPpzWKhxByp//+SN286XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1Z4NOQMerd62yUjLJN36O7cipPl7QkOGtNM8iAmfFpiQf/3d221rHo184ZcXB6Dm
	 seTYdYRDspBjWFnqJUAdRGtkuSH9sN0vTD4xxD5u16qnrSGPGabX5MiaBCuSnOkuO+
	 1frz2TUts6r/fHEuO1hZJF6NgFE3No9cyqReRnZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 398/516] fcntl: refuse F_SET_RW_HINT on an immutable inode
Date: Wed, 28 Oct 2026 17:59:10 +0100
Message-ID: <20261028170012.909190093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit b0d1022b9bdb1e98aa7fb3244fdd50a58c61766c ]

An immutable inode is never written to so write hints are pointless.
Refuse the hint on an immutable inode the way setattr(), fallocate() and
etxattr() refuse their changes.

Fixes: c75b1d9421f8 ("fs: add fcntl() interface for setting/getting write life time hints")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-3-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Moved the check from fcntl_set_rw_hint() to the F_SET_RW_HINT case in fcntl_rw_hint(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fcntl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index a06b51f1af5cf..df1acf6236ee9 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -306,6 +306,9 @@ static long fcntl_rw_hint(struct file *file, unsigned int cmd,
 			return -EFAULT;
 		return 0;
 	case F_SET_RW_HINT:
+		/* nothing is ever written to it */
+		if (IS_IMMUTABLE(inode))
+			return -EPERM;
 		if (copy_from_user(&h, argp, sizeof(h)))
 			return -EFAULT;
 		hint = (enum rw_hint) h;
-- 
2.53.0



