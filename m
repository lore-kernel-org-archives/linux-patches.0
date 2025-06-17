Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A062EE29E;
	Tue, 17 Jun 2025 16:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178416; cv=none; b=kC27Yz/bPiX13HQ+WJ4n8Fb1rlt7Wy5vBMzH7NMiTexOp2JhLMy8lMFc9F6YcP1Vr+bghQ77SaeGus37F9Bsoop+9IFyFQIMdDce1qOt44r5XR7gTvZSU0hQb8fPJiRrFmGvNEak5RpbrC5/ay92itRVmV1jd9kvAcLf3ucnfKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178416; c=relaxed/simple;
	bh=nu5dz44qXDkO90KavZEsA2E5uxSu3s1pt9779iJRMYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rw1fsxL2iMX0BpMUVWm3P7fnghVY8CIaY0AA2fLpncvwwDP+bNMI/isXVwB+R/IF3fM9htkER2vUFBxmRs+5lz3ZasUKF2O/t7lzhhmzrneGCH0qIbJA8y/QGOSspOExKJdGNxAnwz/iW3jdg8J783DCEo1pueg3jn6vrV7Zrpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQs95GPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQs95GPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C425FC4CEE3;
	Tue, 17 Jun 2025 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178416;
	bh=nu5dz44qXDkO90KavZEsA2E5uxSu3s1pt9779iJRMYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQs95GPePNOXXX4zL6N79xqMSn21srmtfZsIsJoQYjOwU3oy7oB2wIijEsu0XOD45
	 PxDE6509lKHow0PNOxS2qOcmzJEI2Z+7fBWvRmjqZX3PGKkz37/pwf6OYuWmIQns7s
	 YZDOwvDQqR9pavsxuc5KU5NEtHvnRjZ4eoj53Fio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Sunil Dhamne <amitsd@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Kyle Tso <kyletso@google.com>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 496/512] usb: typec: tcpm/tcpci_maxim: Fix bounds check in process_rx()
Date: Tue, 17 Jun 2025 17:27:42 +0200
Message-ID: <20250617152439.721960127@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Sunil Dhamne <amitsd@google.com>

commit 0736299d090f5c6a1032678705c4bc0a9511a3db upstream.

Register read of TCPC_RX_BYTE_CNT returns the total size consisting of:

  PD message (pending read) size + 1 Byte for Frame Type (SOP*)

This is validated against the max PD message (`struct pd_message`) size
without accounting for the extra byte for the frame type. Note that the
struct pd_message does not contain a field for the frame_type. This
results in false negatives when the "PD message (pending read)" is equal
to the max PD message size.

Fixes: 6f413b559f86 ("usb: typec: tcpci_maxim: Chip level TCPC driver")
Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Kyle Tso <kyletso@google.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/stable/20250502-b4-new-fix-pd-rx-count-v1-1-e5711ed09b3d%40google.com
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250502-b4-new-fix-pd-rx-count-v1-1-e5711ed09b3d@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci_maxim_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpci_maxim_core.c
+++ b/drivers/usb/typec/tcpm/tcpci_maxim_core.c
@@ -166,7 +166,8 @@ static void process_rx(struct max_tcpci_
 		return;
 	}
 
-	if (count > sizeof(struct pd_message) || count + 1 > TCPC_RECEIVE_BUFFER_LEN) {
+	if (count > sizeof(struct pd_message) + 1 ||
+	    count + 1 > TCPC_RECEIVE_BUFFER_LEN) {
 		dev_err(chip->dev, "Invalid TCPC_RX_BYTE_CNT %d\n", count);
 		return;
 	}


