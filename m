Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCA18563D;
	Mon,  8 Apr 2024 13:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582708; cv=none; b=S5s/m5NT4on8GjDN4XEBXhGZXI+P45lHdx2SGZsmi/SfQB/8VXBmP7azWXgt3XjCzP06m/cEXGFf58bUjOEfVAQEhRecemrN9rVSjx9U6yFYXDmVY/VqDQpMvfT97SCH2M+Lzw0LXIZVaRlmkYkvS6Z9sYYTm8fY9b6zsheYGSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582708; c=relaxed/simple;
	bh=6bA21LoycxpA3S5Cn7AIjAQHJJ8U+iUU4UjhF/EHqdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcl+i7CKiPaSPr1HovujkCk88bhulJUNpeFrBz6myyZvZ7HUED6/BOODr2TOgxlzRbOpXGBw92UqAlBediAO0BvkH+zZ84qcvNiDRxlQrHG/yW6uWdO5cNLpecqKGnELaPGaUx8b/bLqb+aCyDrvosTh1fihsAyM1vnHFpcpEYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5hEMWDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5hEMWDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BD6C433F1;
	Mon,  8 Apr 2024 13:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582708;
	bh=6bA21LoycxpA3S5Cn7AIjAQHJJ8U+iUU4UjhF/EHqdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5hEMWDpqAwiIVnft7tHDUegroLIxiWCcjCsBwZ0/3gWcGenR9USJ9awdyhEfpA+F
	 RllGz0yABN3bWxqsKSlcTqh4XZydCy0Z8kEP8iK4WU0EqRPQeW+XGpIfNX4y3LMaIB
	 0FH8oRgajYmiTRUBEq2lByxtKCl6wUqKhEwmjRQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 127/138] smb: client: fix potential UAF in cifs_stats_proc_write()
Date: Mon,  8 Apr 2024 14:59:01 +0200
Message-ID: <20240408125300.182596240@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit d3da25c5ac84430f89875ca7485a3828150a7e0a upstream.

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_debug.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -568,6 +568,8 @@ static ssize_t cifs_stats_proc_write(str
 			}
 #endif /* CONFIG_CIFS_STATS2 */
 			list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+				if (cifs_ses_exiting(ses))
+					continue;
 				list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 					atomic_set(&tcon->num_smbs_sent, 0);
 					spin_lock(&tcon->stat_lock);


