Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C3779FD;
	Thu, 11 Apr 2024 10:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832511; cv=none; b=vEUzqc7d4Toktl++S4GmGUOxMKgy20Pm7soz9grqe42IkKF3MmgOtRE9kw9xf0UI+xAEEUePW9Rto2zDKgZ1BisQG9xm7Y58Ra/b8SL8/HtxT92pnHqlcGP/uYzrOLu+TGnnpNxEUvVgpxTKTxM6KO7eMDWv9gXzE3LXGwVDGqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832511; c=relaxed/simple;
	bh=pToZaE/5nPHzTqhdj9ZXpTAM4a0t3sgKzzuTcv2Wpo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4pc2qaqkNaeIYxAne6wTALlw/c7IkHHwAZbH1VCwE0roq1DMRR3BHEivaxkyuOZXxfyMHd2KrF38CyOwU8Fl52GUud7v4Wazw0lXJQDjL8gc69ValrNKUrCw84W6UrgoalJGpqba9QXEvypQQgjl7D0UwlHU3PGz1UGD31m2UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLvHBN6/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLvHBN6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7684EC433C7;
	Thu, 11 Apr 2024 10:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832510;
	bh=pToZaE/5nPHzTqhdj9ZXpTAM4a0t3sgKzzuTcv2Wpo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLvHBN6/0B+QwaQ57Ncxd6Ha4p0IOpCJ9GNZl0hWe3bXa6KDJtdIooCIvhNb4RkAI
	 jSuCw8YhIM8ZbsoANzMukxS/4I0okmcWB+2PwgNw7ml4iR81Io0JTWT00YRW3E+aIw
	 qdU65VIcgW4gTo3Nt0kh5esT4Nj9gFeNvA0otA8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 6.1 72/83] tty: n_gsm: require CAP_NET_ADMIN to attach N_GSM0710 ldisc
Date: Thu, 11 Apr 2024 11:57:44 +0200
Message-ID: <20240411095414.852374870@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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
@@ -2969,6 +2969,9 @@ static int gsmld_open(struct tty_struct
 {
 	struct gsm_mux *gsm;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (tty->ops->write == NULL)
 		return -EINVAL;
 


