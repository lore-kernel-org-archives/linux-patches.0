Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ECE16088C;
	Mon, 29 Jan 2024 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548341; cv=none; b=qM6oT3xkhEAjofIOlvFpDpy9HwEwJrWreNDweybkWVd8zQX/WI1K/+wfcAibbzE88ii47l0sgBQYnHskOUX269sUqReKwEtMqFjLGPVvN/he50ihPt0l4jllwoz4H7yJkIlRxxNK3rlabGyjINm+Nwvt0DO2CbiJxZ2HyP008a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548341; c=relaxed/simple;
	bh=xulY5m4TV4zJ1QAuo0miWp3VzAhbM9FbjUbjSzGVR+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6z2B8WctujRxlsmP8DQjBnAvka/sf19FALGXmRnw7nHnDvuHTkoDys+P9cNCMhwyvfPCCNVl/AHyjQH26Y2L2Ed+mPBVGeXWdpP84vBHsUfkwQDHAUJoCw74b2sb7Aq554vjG2LdpvpYCNpi8mWFxbbFbJ2JUqRIJZnr9Xk/Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i09xlhy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i09xlhy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4091C433F1;
	Mon, 29 Jan 2024 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548340;
	bh=xulY5m4TV4zJ1QAuo0miWp3VzAhbM9FbjUbjSzGVR+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i09xlhy4iRF3t/t9pFEb+9Ribfi9qHFmFRUWQvxR12iDYVSODiVDytjPDIhvTNLkz
	 Tr9Za1hRnGqLeWFn9vM9y17EuAFDxHR07aq9LaTaUqhjw0z+cp44pP6QC46eNK8eZ8
	 jn4Q5ZiZ2Mne6yP9FRddb3vTqvbNVESCrcS86Fyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 335/346] spi: fix finalize message on error return
Date: Mon, 29 Jan 2024 09:06:06 -0800
Message-ID: <20240129170026.330618186@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 8c2ae772fe08e33f3d7a83849e85539320701abd ]

In __spi_pump_transfer_message(), the message was not finalized in the
first error return as it is in the other error return paths. Not
finalizing the message could cause anything waiting on the message to
complete to hang forever.

This adds the missing call to spi_finalize_current_message().

Fixes: ae7d2346dc89 ("spi: Don't use the message queue if possible in spi_sync")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://msgid.link/r/20240125205312.3458541-2-dlechner@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 8ead7acb99f3..4adc56dabf55 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1624,6 +1624,10 @@ static int __spi_pump_transfer_message(struct spi_controller *ctlr,
 			pm_runtime_put_noidle(ctlr->dev.parent);
 			dev_err(&ctlr->dev, "Failed to power device: %d\n",
 				ret);
+
+			msg->status = ret;
+			spi_finalize_current_message(ctlr);
+
 			return ret;
 		}
 	}
-- 
2.43.0



