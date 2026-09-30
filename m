Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0E63D3326;
	Wed, 30 Sep 2026 19:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795865; cv=none; b=RIWCiVgEYcq9UUl7Fa4vCZQYo1UesVQmheFzokKCsuZraY+WBP4MOKmsmw3v+8rmsc3QigKFVQLW2TVHn6F3WhbflwqfBJqyxyjd58jrk932JJU2kqNWfcqP36i1wRNyDMrMmwtG8s5tnZki84/X2wKnMAairDAGdtjhXCkGrWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795865; c=relaxed/simple;
	bh=jqgRrsa9nJeR1LKuz4stPHpk8yjG/BWAlRU+8gtqS1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUjXYl4yJUMD3f6GC1OQ40YSO+Zy9/4YscVT/XBPWMTV4P1g6UY5zjDaJGKRde+jAKOFFAM610Lbb8Q58C+kOfsZI64KU656aOow6LVesvHQxN8gBsMC9lDRSSIAvspMoFLmIt3xnoZRtUuJ2Xs7J1nRzlTUhNWpcuxpD9lpPbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGQ8bi9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGQ8bi9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E301F000FF;
	Wed, 30 Sep 2026 19:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795864;
	bh=KRhw2QDDt49xq719UrYkBzOw80+KNghfKmAYxHhlrDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGQ8bi9ASL16sWORSq2vuVeTqCL2pGtcDd/CGeFlwKnZhRagU5XUNshx1CVk22YUx
	 WBY9FyNSX655Xw2v0Y8K+/vcCj4sZxcg20V91cjQIb58xiiuryf3wdJz5P2Ay5SpIY
	 3ueIFujRs0TTe9ODX3AO9n5ooTaMBTCsgnD4vNB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 6.6 0666/1193] smb: client: fix file type corruption in cifs_reparse_point_to_fattr()
Date: Wed, 30 Sep 2026 17:22:30 +0200
Message-ID: <20260930152449.034491089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 6bd360447941357e959414a525aa62576a448116 upstream.

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFLNK == S_IFDIR | S_IFREG).

Clear S_IFMT before setting S_IFLNK for native and SMB1 symlinks.

Closes: https://sashiko.dev/#/patchset/20260906181540.647469-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/reparse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -824,6 +824,7 @@ bool cifs_reparse_point_to_fattr(struct
 		break;
 	case 0: /* SMB1 symlink */
 	case IO_REPARSE_TAG_SYMLINK:
+		fattr->cf_mode &= ~S_IFMT;
 		fattr->cf_mode |= S_IFLNK;
 		break;
 	default:


