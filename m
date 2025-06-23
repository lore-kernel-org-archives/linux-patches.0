Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793B12F24;
	Mon, 23 Jun 2025 13:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684807; cv=none; b=WslG132onXeYJptUThT2Fh8oB84b5kaz0ujTgQC35rSLiwmqyP6ki7Rtf8HuJlQa4ZlrgfS0xZIpT+TMgHK909IZfeCQzgWSu65ke4ocolndGb/rM891Eark1EgrnupfKoKNFKE2Jiqov/UoJE0dbgGT/lW4qxzpHT6fie8kIJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684807; c=relaxed/simple;
	bh=TE+otLoEQsvLVv6gpkqPokOwmYJT8lDZ5f3M8mgUI6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lufTzuXqbUkm2A/BgCO42ytSZgtlDSFWtcCk1JJ4ZHJVVNgAxeVynm3xv4JUiElZLqQLCFTqhZX9u5q52LipQ1CnXJO8OJWGNJjzyuFvLWHnTc4ICm7sRdaUtw3/Wwrog1cxnBXbYNjDqwFP6pNyFk2ARQrBk3Hd/ZxRxEhOfQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TfWsJKDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TfWsJKDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DF6C4CEEA;
	Mon, 23 Jun 2025 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684807;
	bh=TE+otLoEQsvLVv6gpkqPokOwmYJT8lDZ5f3M8mgUI6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfWsJKDYNWcu8p1H6Lwhqk8n6IB1aZ2IXXcQJ2J/NuOtvVRRa8YanmODOVpaSlcVC
	 CBl7/VzYMa/veZGrRruWwaHUl4Wcdzm67D7yJ1BWNK89w6d1xLVw3zq3CmR0Tu3ZcS
	 TQ1BbzPn9fSg/Y3BUtXF6Nm7NBEZY5t8wl62p74I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruben Devos <devosruben6@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 176/592] smb: client: add NULL check in automount_fullpath
Date: Mon, 23 Jun 2025 15:02:14 +0200
Message-ID: <20250623130704.465577423@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


