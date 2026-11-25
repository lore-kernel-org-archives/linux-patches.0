Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621559;
	b=mtWaQF6ZSIuBXg/0H0WO84t4otG+GWssZoks6sw4XzIaAVmSY4entvnDT7v856mdMrb3
	 22Fm9zMyEITOp+GgZso9qFv7Sn0PwImegcEqKGnLBCucZ/DH9//y/ttnBhppELyAdN1he
	 iPD/N1JMGhmPWMYxw6VGddeGSFirsuM9AeDknDtwmxMkAcJ/J0pl/Rr+6qORX5terb/Yu
	 Uhga1WtRzku1Y96DwKF0OmevNoRTnjCYu1AeFIQzvEgXJ1p3/X9ZExNkoLixAaDR1E8i3
	 BaLE2LzvWvl6M9tXVqSUCB9O4XU/EzCGz3TRO3uusIF01ez17MveYSXzTZXHC0pLBZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZGfIHqcR6NS7yt+hXg4gIW7KWEjcLWMQJqSyrnkMCT4=;
	b=sfem3axf+trO94r73mBjkQwzxRhDoaMTTJO8WXj08/+NcZvM7fVwtfUX6lZlV8hrH1Nz
	 ma7os6xYgNYg4mB1+s9bBKnnj1dIbL4ahQvyqbvxFXkDwp234zwDyEiUXKBsrYEh97y7l
	 iBFjNPFhmttN4EsjVmeE2v4gJguDWbG1G5nMLK98TaKDg6dSKzVLVYweOyeSaD2/XRkEC
	 KztAITC/d36OcEz6mq+MghmpHHd46GQleKuoe61f/9giMRqC29YVklEOLa8dX49/UC/xM
	 UGJ/wI0rrE/nFrUfAvpHl3ObnE53rZcWGl3/rJFAHQJ20JObYcE8NXWjIxue8Yt5d6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZiqlQIeL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CBF606A31E;
	Wed, 25 Nov 2026 15:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZiqlQIeL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31F31F000C0;
	Wed, 25 Nov 2026 15:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621559;
	bh=ZGfIHqcR6NS7yt+hXg4gIW7KWEjcLWMQJqSyrnkMCT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiqlQIeLV+U2E0mvzru0Qn8PBjjJGkBmiq4u0bLaYmpg5BAacU0KM4iotXjVQlNz3
	 la+TWXO8EiRRHTw2+GsarILDetTgwpAPjHQtce5sDwhXsQxkCyPxqSVip+CPkZ9Tes
	 V8emlrvxYPwxKF3nl0dS1bIQCbIQgZstt9Jla0Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 265/990] Bluetooth: hci_conn: Fix SCO/eSCO Transport_Unit_Size for HCI data path
Date: Wed, 25 Nov 2026 15:27:12 +0100
Message-ID: <20261125143828.301321962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f7645dc0ad2ae..29e13da009505 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -330,8 +330,10 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
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
@@ -356,8 +358,10 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
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
@@ -387,8 +391,10 @@ static int hci_enhanced_setup_sync(struct hci_dev *hdev, void *data)
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



