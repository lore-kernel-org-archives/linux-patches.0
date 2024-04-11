Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B6714600A;
	Thu, 11 Apr 2024 10:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831043; cv=none; b=jWjWHzdFEf3QuAfPGxXWPBEVzQwq2GlPGYMzyOYjZ34SB4CNX0xrLBZ/elTzbh6QW0Jct10MDBQV0VDhyEZYT9N6qFffflZCLY0kRJk4xccEO0sw6j5hDU2kyerfs724iIM8cVbDYQPhiAZL+W9iVMqljxVl8e34ybjIfGdrC7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831043; c=relaxed/simple;
	bh=6Qj69E2loqQwfbMEASHXVjPGPTyUfpSgWrMITPDlsFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lalEX6RlHn+aiLk2hoQpxfURbaiIIeZ86NISnRdXZ37PpxMN8HVEgKdpxc0RJx+q7IZKj/HsaUeCLuajB5+xpQRbSm3LtAorDGgsDBhBz+31BpNPtXdUkqgzUYz5QXQEgF2er/iMPi/Hw6sR5eTeAY37+sOp7GVtT0RbXWtAWSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1NQ0xdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1NQ0xdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50B2C433F1;
	Thu, 11 Apr 2024 10:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831043;
	bh=6Qj69E2loqQwfbMEASHXVjPGPTyUfpSgWrMITPDlsFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1NQ0xdI9ba19gLBb6j9p32Alytyp4WKZx+F9pRd2qCugUPdIiKmnlLNksWeAGyny
	 4RAVmEhAWtvs2iSHWOLx2gtox8xVdD8f6dM/UmchbUV9uoCmBQq1vTKERp7/8TdDwA
	 ncIRoduS19eFFW0YCgTIpqtnCfw/3wmVdeqaUj/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.4 205/215] tty: n_gsm: require CAP_NET_ADMIN to attach N_GSM0710 ldisc
Date: Thu, 11 Apr 2024 11:56:54 +0200
Message-ID: <20240411095431.016412467@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2567,6 +2567,9 @@ static int gsmld_open(struct tty_struct
 	struct gsm_mux *gsm;
 	int ret;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (tty->ops->write == NULL)
 		return -EINVAL;
 


