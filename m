Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619988;
	b=1/xm87efa1pSgQfV6/OCYnAu6UbMI4j/dgTKhUoCKMtyJw6MTGtUa9mMiGz63R328As1
	 nRAPonE6P3OG2jlvtMJM5blm/bAmvlKKYyROMvEyK/AtMnQYwfeehwqVX7kpw+WBHUzEA
	 RoMBsuFNgxaaX69DQtaPKBnTLPIb/W+IDK1pXjoXlvU5cinUXo/RTckTUuxhWaKxdaflA
	 KGiuF9RldcWhLR1aW+jUawTctBgkdjdTAS1vJaNmXxeseIUoayCmPgpHOBbZ0MvdXXx6V
	 IaoKRM+aQcEkqpgiFFXcGaHZN99DfnAd8qCmZrWCVhaSbB4yTT/gwHoH28MEG95rxXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gtn7dr7zWCQSBcXvoOMvPEtqkWFUB75/nIsNERQeLTU=;
	b=Q3dbDwVzj3v0bnKKiuyQL4w21qkJqgQgLnubu6BeS91T1EmiLnovzEobWJ42+2T0jCPJ
	 fENWgqe6Rur2eMQrsSxPVmt9qy3p6mopHtkWFPhlhiyCwKRkC8Role/fMd4Id0or/+877
	 PmuPAE1ReUwry2T4pd+9QRx7NNowXC18unBWTnnBK6Jxp15ZRZaf9ZmhO/l6uQnUoORRX
	 XUKvEJRt3U08guQPXb6m2Y5XNT+92HylMYkOZvBiAs9jFZgja4oMIXDZwHl089TqUbp3A
	 U49S30pxhIat+QUEKLqSZTMZvlY5PNeB+ta23dWbr3fmoDjnJDb4sW1ay0T03OsdsbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qa4EjZ8d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED8B606A31E;
	Wed, 25 Nov 2026 15:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qa4EjZ8d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3B01F000C4;
	Wed, 25 Nov 2026 15:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619988;
	bh=Gtn7dr7zWCQSBcXvoOMvPEtqkWFUB75/nIsNERQeLTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qa4EjZ8dznSnGtrudxhvTJ5NYsiB2dpTjCMolGRDQkU9sToGJO4I8Wx8F0X/dc4EQ
	 wX6q3O8QWVtVzSJg+3rJX9SIXZA48WBVAAyqVyY8k8GL0HbYNc2GOvrxr7s+eQofF1
	 mMUy5nc2o30Drn78P432f2lt2f29vT87eSVN5edI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 0771/1005] ksmbd: keep group denials when a POSIX ACL entry decides access
Date: Wed, 25 Nov 2026 15:35:09 +0100
Message-ID: <20261125143839.805879255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

commit b0af9a3e6b1534d353ca6ac23caaf46127f62e4a upstream.

When no ACE names the caller, Everyone or Authenticated Users,
smb_check_perm_dacl() lets a POSIX ACL entry for the caller decide
access. The entry's rights replace the result of the DACL walk. Deny
ACEs for the caller's groups, and OWNER RIGHTS for the owner, are then
lost.

For example, a deny of FILE_WRITE_DATA for one of the caller's groups
should refuse writes. A POSIX ACL entry that gives the caller write
access still lets the caller write.

Remove the requested rights that those ACEs deny from the entry's
rights. The DACL walk already records them in grp_denied.

Fixes: 42ac1f1917ae ("ksmbd: grant a caller what its groups and OWNER RIGHTS ACEs allow")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261102200353.884509-1-icb%40fastmail.org
Link: https://sashiko.dev/#/patchset/20261103150458.11591-1-icb%40fastmail.org
Link: https://sashiko.dev/#/patchset/20261107062233.1579198-1-icb%40fastmail.org?part=1
Link: https://sashiko.dev/#/patchset/20261107231941.1824289-1-icb%40fastmail.org?part=1
Link: https://sashiko.dev/#/patchset/20261108182011.1888520-1-icb%40fastmail.org?part=1
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1703,6 +1703,15 @@ next_ace:
 					if (!access_bits)
 						access_bits =
 							SET_MINIMUM_RIGHTS;
+					/*
+					 * Only ACEs for the caller's groups,
+					 * or OWNER RIGHTS for the owner, apply
+					 * here. The POSIX ACL entry does not
+					 * grant an explicitly requested right
+					 * that they deny first in DACL order.
+					 */
+					access_bits &= ~(grp_denied &
+							 requested);
 					posix_acl_release(posix_acls);
 					goto check_access_bits;
 				}


