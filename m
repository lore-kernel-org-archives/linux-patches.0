Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9427B7602A;
	Mon, 15 Apr 2024 14:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191218; cv=none; b=jjJdpfXmgOLaeIuF5L0ogPR9cqd8yJ439JjiWOgvLexUA+XOO46Wk8Zr3RwDkhHUh80xvc17Bp3K3GfcRIoVRnn7DjxDQuM6ltSuyKF3izB8O7QUdPc9kCoHiR5Qyy18DHq1re9lHP4x3lpjzc4SUXKJkA2irGKCLpc2nGO/XYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191218; c=relaxed/simple;
	bh=dcP/buCKKPsOz+jzh2/aM9/5bysm1epOjnNi14E5or0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHEi93W/N3E/1ozwVVeMH2WZi8zCDjFEqscBh7Bu/GB7NOPn6C+B0ei6t7B/Lh0gXT5MWOqWnP9pXVW7sIcr32UdmSuAjIRr6nnM4863qkUvm3GeWJr4LurcY7vDtvDGO1yZJMYBe7AU9xJ/dJZCbOgrxpvJOGoe397RkvnFGAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyPeehht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyPeehht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4890C113CC;
	Mon, 15 Apr 2024 14:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191218;
	bh=dcP/buCKKPsOz+jzh2/aM9/5bysm1epOjnNi14E5or0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyPeehhtO3My6g+OlkyWgRxbLAdF++dWUEky84jG6V8TJMaEesGVTHZ4j21PXHRUv
	 1sYJrXRfyyONyRgOPfZheUWkQgeDPS7UxhEPziA2uNjvqJ+vNNB26y4s7RtBOj/LNx
	 +hkQ45nXV2Lx7y63Hrhlskfls1rmHoBRW7WJzT8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 071/172] Bluetooth: ISO: Align broadcast sync_timeout with connection timeout
Date: Mon, 15 Apr 2024 16:19:30 +0200
Message-ID: <20240415142002.564244492@linuxfoundation.org>
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

[ Upstream commit 42ed95de82c01184a88945d3ca274be6a7ea607d ]

This aligns broadcast sync_timeout with existing connection timeouts
which are 20 seconds long.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: b37cab587aa3 ("Bluetooth: ISO: Don't reject BT_ISO_QOS if parameters are unset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/bluetooth.h | 2 ++
 net/bluetooth/iso.c               | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 7ffa8c192c3f2..9fe95a22abeb7 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -164,6 +164,8 @@ struct bt_voice {
 #define BT_ISO_QOS_BIG_UNSET	0xff
 #define BT_ISO_QOS_BIS_UNSET	0xff
 
+#define BT_ISO_SYNC_TIMEOUT	0x07d0 /* 20 secs */
+
 struct bt_iso_io_qos {
 	__u32 interval;
 	__u16 latency;
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 04f6572d35f17..4fa1f3b779a71 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -837,10 +837,10 @@ static struct bt_iso_qos default_qos = {
 		.bcode			= {0x00},
 		.options		= 0x00,
 		.skip			= 0x0000,
-		.sync_timeout		= 0x4000,
+		.sync_timeout		= BT_ISO_SYNC_TIMEOUT,
 		.sync_cte_type		= 0x00,
 		.mse			= 0x00,
-		.timeout		= 0x4000,
+		.timeout		= BT_ISO_SYNC_TIMEOUT,
 	},
 };
 
-- 
2.43.0



