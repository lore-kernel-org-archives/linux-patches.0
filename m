Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612041448F3;
	Thu, 11 Apr 2024 10:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830007; cv=none; b=FtYl9z9A/EC6Xx1JDazwq8SPPaWSxrPXURNcoNlfLmpE8G/lMqd25L1+qhLSUGzZJTSyGDbhZ9NtRlwTyZabREO3qD94iOXUAkXAMMD/7Uz0Gu1tNyE87ELn+0ipnVSABtBd3C5sDVSF0Gx92iWoSvQr97c6C/8nsJ4m4FdlBpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830007; c=relaxed/simple;
	bh=BVVNbrhk2MKN6Tpeh5g4ewAAh7XjlFTm48OKSNFSBjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Djw732GcOZKyuNoHkhwwD2h3jr4FtWd0uvRFcjDg68v1Zhk3Vj7ytrC9eDUoObmesyVlHBuRAaFAY4isVJ/jnxGcVtHmi1DXzBHRmKrxpIEV7HZJ1N/M1PXTe5TD1D1ht4QOpPCbg3JBB/7tK/3/Ijm4sbwPRkKfBbtM5Ca+u0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmP9SflK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmP9SflK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BC3C433F1;
	Thu, 11 Apr 2024 10:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830007;
	bh=BVVNbrhk2MKN6Tpeh5g4ewAAh7XjlFTm48OKSNFSBjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmP9SflKHlY+9/1QvuhcZ8/bX7Ah/7zuzAHMR3Ip0Mhu4bQuP/jCfDQmlXp05RSU9
	 ZSFiyNkRjMpgYiegbNWYmwBP3NrOT8g20Vekn+vtITVAcNl2xx1ZNbfTr9KDIXYizV
	 O6CEMj6i4dlHga6DZZDCGEjhYPSvUZv1Z+N0BlLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.19 167/175] tty: n_gsm: require CAP_NET_ADMIN to attach N_GSM0710 ldisc
Date: Thu, 11 Apr 2024 11:56:30 +0200
Message-ID: <20240411095424.591801181@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 67c37756898a5a6b2941a13ae7260c89b54e0d88 upstream.

Any unprivileged user can attach N_GSM0710 ldisc, but it requires
CAP_NET_ADMIN to create a GSM network anyway.

Require initial namespace CAP_NET_ADMIN to do that.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Link: https://lore.kernel.org/r/20230731185942.279611-1-cascardo@canonical.com
From: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2435,6 +2435,9 @@ static int gsmld_open(struct tty_struct
 	struct gsm_mux *gsm;
 	int ret;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (tty->ops->write == NULL)
 		return -EINVAL;
 


