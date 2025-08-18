Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B40258EDE;
	Mon, 18 Aug 2025 13:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523300; cv=none; b=cQBvXGnohec8BYKGp4y53Rk1eMfxSJc9v+UadMjsclZge5sqdzIx9E68Y52wbyL0D7E039qG2+TRMg+tJ0cY1FLktgIzGjM0BNosbJJ4bebbo9/NGsh68wXCO2vtkv77z9vjtje/t4VvbOHL5uGFav8vet6G7LIOl21mtMsCNtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523300; c=relaxed/simple;
	bh=ZwTORpMIObtnuIYLIw6nOWeipw9v7+yRX9DKwsLC5z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHOLzaSvdPRMaAu0ldvQMGp9dYa99WyGAbKCcg5Pbo/lPoguFh6zggfPePiriMezmXNQDjJ8mgXoISpytRKM+vY60NF/HUFqtp/+Ri2JrnMARW4Ww7obRJfs4Pbw8n1AcCfq+10QW/MsxoXpr3nk5CGp5olkBtQzfe1YsKap/bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZ6BFsPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZ6BFsPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36978C4CEEB;
	Mon, 18 Aug 2025 13:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523299;
	bh=ZwTORpMIObtnuIYLIw6nOWeipw9v7+yRX9DKwsLC5z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZ6BFsPOGOPnNpBC7obHMK4qFBUw2F1QL+1xaH3rstv84q3YDZK2OrV241ne2ZBb0
	 O0O5CEeOotJqlW/PSoUZFB1bbsZJzxlJKby5Hfrd9CbDeklDUqv1nMFEHqep/Gi8bD
	 Lthbh0r+1C+TStCc6pMhiPXpdkDBrnWHLUguqdIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 129/515] usb: typec: ucsi: Add poll_cci operation to cros_ec_ucsi
Date: Mon, 18 Aug 2025 14:41:55 +0200
Message-ID: <20250818124503.368539887@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Jameson Thies <jthies@google.com>

[ Upstream commit 300386d117a98961fc1d612d1f1a61997d731b8a ]

cros_ec_ucsi fails to allocate a UCSI instance in it's probe function
because it does not define all operations checked by ucsi_create.
Update cros_ec_ucsi operations to use the same function for read_cci
and poll_cci.

Signed-off-by: Jameson Thies <jthies@google.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250711202033.2201305-1-jthies@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/cros_ec_ucsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/ucsi/cros_ec_ucsi.c b/drivers/usb/typec/ucsi/cros_ec_ucsi.c
index 4ec1c6d22310..eed2a7d0ebc6 100644
--- a/drivers/usb/typec/ucsi/cros_ec_ucsi.c
+++ b/drivers/usb/typec/ucsi/cros_ec_ucsi.c
@@ -137,6 +137,7 @@ static int cros_ucsi_sync_control(struct ucsi *ucsi, u64 cmd, u32 *cci,
 static const struct ucsi_operations cros_ucsi_ops = {
 	.read_version = cros_ucsi_read_version,
 	.read_cci = cros_ucsi_read_cci,
+	.poll_cci = cros_ucsi_read_cci,
 	.read_message_in = cros_ucsi_read_message_in,
 	.async_control = cros_ucsi_async_control,
 	.sync_control = cros_ucsi_sync_control,
-- 
2.39.5



