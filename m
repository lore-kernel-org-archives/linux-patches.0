Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A17A1E89C;
	Wed,  5 Feb 2025 15:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768574; cv=none; b=Z7mjAqPmCMfheOPEp4WEaOo+MfHdG7QcukxJhUJDM1ejnQxfc+BlRZ7DOwOFuK+Wbr3/LDl5pA82z0G05sYBmYdJJGY2YhU/KRnFirEmoWHnps2/OzQQpIV/rDaaws0JkDEnhq04hwf62Lz9IjesMfCB1VO/Tfkzsh8qESPoF0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768574; c=relaxed/simple;
	bh=jS484aciodcVnfooH83w1klhZfCKVDBR+SY0lWexCtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bf9vZw+4YvQGMqrn0UgnTa7zobRfCE56GqIXWoMcGfSkrz+oYw8azb3wqcZkDE+FX/LNrvh651YrNkKpyI1Fzvk8nYKbJLAzXgexzcL5JIwUCiYKrh2GNlZ6ZaEWl5eTNYsT8mlitDpgEus1Nikrd28umB4FeKlrVpfkbKJyGBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQw8TE8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQw8TE8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C8DC4CED1;
	Wed,  5 Feb 2025 15:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768573;
	bh=jS484aciodcVnfooH83w1klhZfCKVDBR+SY0lWexCtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQw8TE8m+ke2F2js6RJQrwvFpN4QcX2OeWXxs4OZ7r6ZBHG8GrulVlJ240OXLx/pB
	 qWNWi4E/eNXFo79U67bwGHAT2qJlNbP7MciHT6i1GCYgz+VMq8NqCrtA6/HxYZkFYY
	 PIH7r9eoI4OEsbBWE36Uo4QCFkmEI7sH/NmNIVZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jos Wang <joswang@lenovo.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.13 596/623] usb: typec: tcpm: set SRC_SEND_CAPABILITIES timeout to PD_T_SENDER_RESPONSE
Date: Wed,  5 Feb 2025 14:45:38 +0100
Message-ID: <20250205134519.024415333@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jos Wang <joswang@lenovo.com>

commit 2eb3da037c2c20fa30bc502bc092479b2a1aaae2 upstream.

As PD2.0 spec ("8.3.3.2.3 PE_SRC_Send_Capabilities state"), after the
Source receives the GoodCRC Message from the Sink in response to the
Source_Capabilities message, it should start the SenderResponseTimer,
after the timer times out, the state machine transitions to the
HARD_RESET state.

Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable@vger.kernel.org
Signed-off-by: Jos Wang <joswang@lenovo.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20250105135245.7493-1-joswang1221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4772,7 +4772,7 @@ static void run_state_machine(struct tcp
 			port->caps_count = 0;
 			port->pd_capable = true;
 			tcpm_set_state_cond(port, SRC_SEND_CAPABILITIES_TIMEOUT,
-					    PD_T_SEND_SOURCE_CAP);
+					    PD_T_SENDER_RESPONSE);
 		}
 		break;
 	case SRC_SEND_CAPABILITIES_TIMEOUT:


