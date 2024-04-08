Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566967EEF2;
	Mon,  8 Apr 2024 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584028; cv=none; b=kO5FDKJd2+Pf30fknB3VVTmJUkzY0lVBvdytzZJD8ZldXlVWIF00a9tMuNNmw7n5k/bOI5kTKfUoYWqILlWSLZ/9gABd/xVd0vD977/p6M+riIDh40dxfd3WxYpjUd+R+ulhihaXKWCMLZeJ9G3tquG4WdhsnLtZBTPoDmp26gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584028; c=relaxed/simple;
	bh=ZwUILrMwVKJz2KujSalkHUXphMabkP/AZ4+n/OaZMv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUC398/AgvPPaaC0sXPSghAgR9HKS7PiFo8SV284SYlTPMwcDrE5QrfRIH/cEV+zTWEbsfQdg6J+4X98bXILtIHGxiZubYlhLOCH+2Ge9NgznyuvSyVOf3Jiri8E8/p6K3170hYedbVNzl1RkrnkLF6G40HnonUXBkCXmeYqHSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8+0ypZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8+0ypZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B05C433C7;
	Mon,  8 Apr 2024 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584027;
	bh=ZwUILrMwVKJz2KujSalkHUXphMabkP/AZ4+n/OaZMv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8+0ypZ6cV8qs3+uzoKBxla3i+rFT5/cPLdjaVpMdy3BTfKolAJxstCHTgZRO2eZy
	 WDEISdH/YnsEZwUHqyI/aW7ujZ9PqpwEjn6T/2pNLiwqA/H9AhxECjJVIU4hpxbbOg
	 x1bzPJJ2Lwc2jBj00jHXkLKWfHaxQZpT+s/TW9Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 250/273] smb: client: fix potential UAF in cifs_stats_proc_write()
Date: Mon,  8 Apr 2024 14:58:45 +0200
Message-ID: <20240408125317.214388145@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -658,6 +658,8 @@ static ssize_t cifs_stats_proc_write(str
 			}
 #endif /* CONFIG_CIFS_STATS2 */
 			list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+				if (cifs_ses_exiting(ses))
+					continue;
 				list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 					atomic_set(&tcon->num_smbs_sent, 0);
 					spin_lock(&tcon->stat_lock);


