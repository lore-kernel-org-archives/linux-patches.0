Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0A3221FBE;
	Mon, 23 Jun 2025 21:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713957; cv=none; b=Remd0NwDLDKYtnbbBQoNJy3vNsDngB/IeAxuFJgzTF5BBnTgVF9V584Sq7RKfywBTnuQpIA0GLtqWgw61YNlj2fy9+ldW37gZBy4pGBq7JtixFQ7o3x918TKcay+Pnl14Uj5ShiQsrmtD4US82SmDjgysDnXMHN+7InSzxqoNt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713957; c=relaxed/simple;
	bh=5tKfD6x+UiCOAFfso5Amm5/oS2bcDsALp2njnij2gzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6gVzywwrCWOwaa8uvst45IiItIYzyPeo0sWPjr3ods0XWCXtkh5EW1Tdsqu8u+TJWOX+2D3ox7INRlIq61FQUC/hCT76jIQbo0iQnZcvE+JqsA8uYVg/jMl7QbXRx49lWlauX5RfLYL0Q5leu0eBxI+6MGC+ddy1eQb1jZ1460=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzdeJU5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzdeJU5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A82C4CEEA;
	Mon, 23 Jun 2025 21:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713957;
	bh=5tKfD6x+UiCOAFfso5Amm5/oS2bcDsALp2njnij2gzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzdeJU5oGq3Vr6OSanp0PubDBjJmne3Bcc5hZhRPqI8IZ/0mc742ydjHT9smcru+l
	 KbgXpEFuyifrgAuwk7xN1R5g6Q03DB6QZjLrLCG0apPBtyCO86/Q5sHTM/3/6L2rtn
	 S3rCh12BKKs2nmKoL/yKR/0euAdVLOcUMRkQCKAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruben Devos <devosruben6@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 105/290] smb: client: add NULL check in automount_fullpath
Date: Mon, 23 Jun 2025 15:06:06 +0200
Message-ID: <20250623130630.114342626@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ruben Devos <devosruben6@gmail.com>

commit f1e7a277a1736e12cc4bd6d93b8a5c439b8ca20c upstream.

page is checked for null in __build_path_from_dentry_optional_prefix
when tcon->origin_fullpath is not set. However, the check is missing when
it is set.
Add a check to prevent a potential NULL pointer dereference.

Signed-off-by: Ruben Devos <devosruben6@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/namespace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -146,6 +146,9 @@ static char *automount_fullpath(struct d
 	}
 	spin_unlock(&tcon->tc_lock);
 
+	if (unlikely(!page))
+		return ERR_PTR(-ENOMEM);
+
 	s = dentry_path_raw(dentry, page, PATH_MAX);
 	if (IS_ERR(s))
 		return s;


