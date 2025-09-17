Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B871F09A5;
	Wed, 17 Sep 2025 12:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112918; cv=none; b=K9KwRORAiPJvHHW3D5yIKgVKdGkn7NK4/vUUlZpMqBjgfVwHxJMGV4WBLvftRlSGmWYJE2536FUKHLC35TCrKSy9/G+nV3RMHA8XTtAhTOGoVL8wvhsARD47fb0w/wLammQsfgK+LG7iaVbe00kM4CgWzghN8pB6QnDZf4zg1Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112918; c=relaxed/simple;
	bh=2N+JK+YAkfjEHoMEefJXp3eWoXjv429TzMduiNIHe90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Boplkeel+UpJ+lNyPrmxf4tn2nEmkDuqduuQ7ZCURNObCXxFDy14u9ivgjsfVlL67pTqmwbY/eIsH/dL4N2CfbZ/Nq8OjI0/j8Nn+n0cGWfk/YzEBMjqWlWqKHIwi3037RwWhsNIdPqN2HhvcbD71iItnJwYC1dll64ZWR//nqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xv8zJYo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xv8zJYo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6292DC4CEF0;
	Wed, 17 Sep 2025 12:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112917;
	bh=2N+JK+YAkfjEHoMEefJXp3eWoXjv429TzMduiNIHe90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xv8zJYo0UkSypu2Ebim4A2IqiZABDApuqK+NSKXnZAfKFkAJhuyZAhBEKGX6H7LAi
	 feoKap+TJjoTnqLD/s4iBSbt1j9X/USfGvQ0ha2v+IzZvWqAAZ3N/MuFYKjthn/oZB
	 Tu2M7dVpP0Pmx3tdG/tpd2lgQB9NfKL3eLPz9D8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.16 116/189] Input: iqs7222 - avoid enabling unused interrupts
Date: Wed, 17 Sep 2025 14:33:46 +0200
Message-ID: <20250917123354.698838657@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff LaBundy <jeff@labundy.com>

commit c9ddc41cdd522f2db5d492eda3df8994d928be34 upstream.

If a proximity event node is defined so as to specify the wake-up
properties of the touch surface, the proximity event interrupt is
enabled unconditionally. This may result in unwanted interrupts.

Solve this problem by enabling the interrupt only if the event is
mapped to a key or switch code.

Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/aKJxxgEWpNaNcUaW@nixie71
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/iqs7222.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -2427,6 +2427,9 @@ static int iqs7222_parse_chan(struct iqs
 		if (error)
 			return error;
 
+		if (!iqs7222->kp_type[chan_index][i])
+			continue;
+
 		if (!dev_desc->event_offset)
 			continue;
 


