Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624512;
	b=jkV32kgFlZojBQuV7LUbrecJ9L+fune6/BxxXBzzOe2FqBVm3HHMgBvL2rLGj2vmqSTW
	 9bDqWgNxqvEedbaSuSEqhqGa9dLAVw0xbm6v40mqJhX0CZPm14uM4cnT1PhIqaiFQCvUn
	 kZwzOOK2JVHk2jBD/YQ2PNQwjVkb9zPlyjKWzddsCfil/ZfXKsGs90KWEPkBXS1E5JjjK
	 nPUBE2f+mrbN72PRso01Dt65D17JvKws2Qzlp24GFS9TN5V1sC+7OWQQGuNXbyfj5TP4e
	 ciTITZT2AEMwhozrpIk1rdH2WC52GqV9uUEHOMb8MJp5O/ZVJ5D/j1QNEMK8vdWSDRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ClFIfabbIg2t1acctOjqy01suYuZxc/rX4RL8RDqB44=;
	b=hNuOd6AdI6K+3edndIWPudT8BG26HnpzZkpiIsMd3dluhP3CrmcCVqVMrVGGCXvrcaj9
	 kwLeFdqFOCrIABqGVdlXZnYLhSR/gNNgUfJFuRzsqpsjN6zXVD8GZ3Uo+vBF9N0hPgnHl
	 KtejoAHS8DMmSEFyCc1xEyEx4DajttWDrejU3cDUR9mqsMS4YkhVOF1KFJExVGf8zebJw
	 8G8q/ytwU5ZYbq/OxkElDAoMhPjIwT8EdZNi/n/lxQCu6Kk5ZnSbjvQw/BdRjVhNFiy/0
	 ui5SlxRokB0cgSbHuYFiZ7ilmxipm11msqvHB6A/NAyaclZA8Qn+vN+OZCx2jXKDFmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JmASnOIH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55BC606A336;
	Wed, 25 Nov 2026 16:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JmASnOIH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DA21F000C4;
	Wed, 25 Nov 2026 16:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624512;
	bh=ClFIfabbIg2t1acctOjqy01suYuZxc/rX4RL8RDqB44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JmASnOIHAip5cHxl4e63hNsZUvI+vXqsWZt+FVw+U0iApJJYi+I6Gh8sv68zjRhuA
	 YLaZ3t++JgbvPg471oXzArhr/xLSzG+9omyH//ssCbCjUZjnmExr0li7AlA2BNtBQh
	 l5YBtAbgDJgNeTB3PcEuOk0rrl/+WymkwFonyK2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/816] Bluetooth: hci_conn: Fix SCO/eSCO Transport_Unit_Size for HCI data path
Date: Wed, 25 Nov 2026 15:29:23 +0100
Message-ID: <20261125143854.179053950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 3efdadae3a252b14ca1f62b16e31a9aa7c5d30cf ]

Correct (Input|Output)_Transport_Unit_Size based on Core spec v6.3,
Vol 4, Part E, 7.1.45:

  "The Host shall set the Input_Transport_Unit_Size and
   Output_Transport_Unit_Size to be equal. For HCI Host transport
   the Host shall set them to 0."

Fixes: b2af264ad3af ("Bluetooth: Add support for HCI_Enhanced_Setup_Synchronous_Connection command")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index c1d1614581a29..56276caf655a6 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -331,8 +331,10 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
 		cp.out_pcm_sample_payload_msb_pos = 0;
 		cp.in_data_path = conn->codec.data_path;
 		cp.out_data_path = conn->codec.data_path;
-		cp.in_transport_unit_size = 1;
-		cp.out_transport_unit_size = 1;
+		if (conn->codec.data_path) {
+			cp.in_transport_unit_size = 1;
+			cp.out_transport_unit_size = 1;
+		}
 		break;
 
 	case BT_CODEC_TRANSPARENT:
@@ -357,8 +359,10 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
 		cp.out_pcm_sample_payload_msb_pos = 0;
 		cp.in_data_path = conn->codec.data_path;
 		cp.out_data_path = conn->codec.data_path;
-		cp.in_transport_unit_size = 1;
-		cp.out_transport_unit_size = 1;
+		if (conn->codec.data_path) {
+			cp.in_transport_unit_size = 1;
+			cp.out_transport_unit_size = 1;
+		}
 		break;
 
 	case BT_CODEC_CVSD:
@@ -388,8 +392,10 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
 		cp.out_pcm_sample_payload_msb_pos = 0;
 		cp.in_data_path = conn->codec.data_path;
 		cp.out_data_path = conn->codec.data_path;
-		cp.in_transport_unit_size = 16;
-		cp.out_transport_unit_size = 16;
+		if (conn->codec.data_path) {
+			cp.in_transport_unit_size = 16;
+			cp.out_transport_unit_size = 16;
+		}
 		break;
 	default:
 		goto unlock;
-- 
2.53.0



