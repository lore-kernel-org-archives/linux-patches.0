Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F192E0B6A;
	Wed, 17 Sep 2025 12:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113436; cv=none; b=a9yIsy58lX88urRd+iVwx0LXsw0HBe8esd7zc7t1xU+2FGsvi0jwzja8QSsFh+ULxv0qZl48AQtvAM52kwqm3mTfrr2bD72qLBKoFilcqVh97dQhM1qASumOIfQYfZwAteHFvAWWrEyb7nEYmiBIQGfPb8XAsosUWDTa2E56StM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113436; c=relaxed/simple;
	bh=Pjbq0wbsYPeB/9fM6erc7BOPZiGnzjYkR5iKw3e+WOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aorNdhN5ccG2TU7bgdxuaWuKVySFFB4lO+M9n19MJhAmD4NWglM4RZtQeif1YUqJAhZB+11uVmYp0hbZTEIzVS59muxulKErfNnwdE80ouDIcqWPiXIgLm6jdFQS5SVTPNpIGHCCbns285Vj+8FsoejeN65F6ysAmk+nSm/QKqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUTNVnQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUTNVnQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1659C4CEF7;
	Wed, 17 Sep 2025 12:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113436;
	bh=Pjbq0wbsYPeB/9fM6erc7BOPZiGnzjYkR5iKw3e+WOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUTNVnQCrpOjnPV6yyLIISydNt+roj7XhVHz4iFeZ2dE8+hr5H1yjpgBYxh+rrt+x
	 HMlmLxbJRrmmNVulF/xsqGMK/L/NAQD5lunQbMvvhZwz71L8OP1ipBDlZzC7wQVVAi
	 1A0LkELjQeRu89RVydEy8AXHC7DKwrG+qGobIE+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 086/140] Input: iqs7222 - avoid enabling unused interrupts
Date: Wed, 17 Sep 2025 14:34:18 +0200
Message-ID: <20250917123346.411228817@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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
@@ -2430,6 +2430,9 @@ static int iqs7222_parse_chan(struct iqs
 		if (error)
 			return error;
 
+		if (!iqs7222->kp_type[chan_index][i])
+			continue;
+
 		if (!dev_desc->event_offset)
 			continue;
 


