Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74727757EA;
	Mon, 15 Apr 2024 14:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191221; cv=none; b=p3E528hcN5/LAXe9yZljGE9t4jpWim1yEEFTJtARUjyQeJmuYHicMA8k13F2D7ECD+zOssMIk51PaLdutx8bhgoR+EmA+VglbSBAOwKfyH2CZoFiEUALRB/qDPbb4Bb1rA7E75shcNQkFgDV7j3+kS4zUhfxE9krYfWNklBxwGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191221; c=relaxed/simple;
	bh=QxwEuKhBx45N+1bJd0T53yhn2/ways45Klv0kBdy9V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0XtqU+g8pFwMj6FVmhaKeikVdKxsrZ4fQt+EP2CwyRY1d1Fen3My3rQT9IIdeUAjpqSE/PrxSz/7Mk9jn3lx9oDAwHbrBbjPDK1e0o6+ETd3MH3NEkhNmluaf9nM/R9RJXdXUXz68073WEInQG7kMfqDYFyC+RGzCcUzdncPfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdDvRcj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdDvRcj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02E6C113CC;
	Mon, 15 Apr 2024 14:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191221;
	bh=QxwEuKhBx45N+1bJd0T53yhn2/ways45Klv0kBdy9V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdDvRcj4qoAyYCLVlTx7Z8v5GVBl/Y+nM/iIgPupyISZRB/vEkDIfL82yGnZ+Yo+s
	 69CpvYJTKwlBWJyh9JDhp8YdsJomr1EG5Tq+52ZKo83qGWwLzODaTVG0HeHg4F2cl+
	 mQkjZnCah62JiyM2wVIbRnVsxZdb82yUVVFOvsRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 072/172] Bluetooth: ISO: Dont reject BT_ISO_QOS if parameters are unset
Date: Mon, 15 Apr 2024 16:19:31 +0200
Message-ID: <20240415142002.593399773@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit b37cab587aa3c9ab29c6b10aa55627dad713011f ]

Consider certain values (0x00) as unset and load proper default if
an application has not set them properly.

Fixes: 0fe8c8d07134 ("Bluetooth: Split bt_iso_qos into dedicated structures")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 4fa1f3b779a71..3681e3673654a 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1430,8 +1430,8 @@ static bool check_ucast_qos(struct bt_iso_qos *qos)
 
 static bool check_bcast_qos(struct bt_iso_qos *qos)
 {
-	if (qos->bcast.sync_factor == 0x00)
-		return false;
+	if (!qos->bcast.sync_factor)
+		qos->bcast.sync_factor = 0x01;
 
 	if (qos->bcast.packing > 0x01)
 		return false;
@@ -1454,6 +1454,9 @@ static bool check_bcast_qos(struct bt_iso_qos *qos)
 	if (qos->bcast.skip > 0x01f3)
 		return false;
 
+	if (!qos->bcast.sync_timeout)
+		qos->bcast.sync_timeout = BT_ISO_SYNC_TIMEOUT;
+
 	if (qos->bcast.sync_timeout < 0x000a || qos->bcast.sync_timeout > 0x4000)
 		return false;
 
@@ -1463,6 +1466,9 @@ static bool check_bcast_qos(struct bt_iso_qos *qos)
 	if (qos->bcast.mse > 0x1f)
 		return false;
 
+	if (!qos->bcast.timeout)
+		qos->bcast.sync_timeout = BT_ISO_SYNC_TIMEOUT;
+
 	if (qos->bcast.timeout < 0x000a || qos->bcast.timeout > 0x4000)
 		return false;
 
-- 
2.43.0



