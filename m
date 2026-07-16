Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439DD400989;
	Thu, 16 Jul 2026 13:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209787; cv=none; b=t9CSsz4B+JuijM/+ZJiKw3xe1N16hGMWoKhqtcqiOuOcfqLracQlB/jUeU+rxYwwAnZ/Kd0CN88XdpvdoV0DeU0KEmz9uHVIgk58lo+LBzs214ywQnTAF7WZKTOTgmQHAEUuFs5aWhgRYGabiKFmVkE1b2567EwP7QFiGl6wvAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209787; c=relaxed/simple;
	bh=8VHpvgArdfUOJJl+rmIQ7SVKC5+aTdW5GN5AI7q+HEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alTC5KFFBihqpoh/5BKnpdXfonVEAy4V7i2wb7ZDxsDffBbhVPXe1TBG9AZ5Bymyt+9OS05ZfA52Pm1Ngn1ujAhLj/SWaXSlRYbv9Ype8oJ+8d3RU1X8OWx+Hj0VxCbxO4VSOBhXvMqeU+pF0nGQe181pvEYDMT4uWrEdZt1mj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CemjlTSB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CemjlTSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCE71F000E9;
	Thu, 16 Jul 2026 13:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209783;
	bh=Ang6aq7ZiUGoA1h7EHPjdsU/wwoVZexc3IZp9FvT40o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CemjlTSBLw31BYTv/IXmgG48EwQ2fyJgnbufZis2y3PTzEIoL5BI+rp4uQVh5cD9N
	 TuEIsA001ALmNGQ6sLRBzHvKmEAUl7IECS7J0AIGK69wie4+GOFiJTXgdnf0JVcgmL
	 HJhDujls9IU1dBw/0kiLyNBjgGufORSTjx08D9z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.1 318/518] USB: serial: keyspan_pda: fix information leak
Date: Thu, 16 Jul 2026 15:29:46 +0200
Message-ID: <20260716133054.779656904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6bfc8d01ac4068eced509f8fc74d0cd205e4dcec upstream.

The write() callback is supposed to return the number of characters
accepted or a negative errno. Since the addition of write fifo support
the keyspan_pda implementation will however return the number characters
submitted to the device if the write urb is not already in use. If this
number is larger than the number of characters passed to write(), the
line discipline continues writing data from beyond the tty write buffer.

Fix the information leak by making sure that keyspan_pda_write_start()
returns zero on success as intended.

Fixes: 034e38e8f687 ("USB: serial: keyspan_pda: add write-fifo support")
Cc: stable@vger.kernel.org	# 5.11
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan_pda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -518,7 +518,7 @@ static int keyspan_pda_write_start(struc
 	if (count == room)
 		schedule_work(&priv->unthrottle_work);
 
-	return count;
+	return 0;
 }
 
 static void keyspan_pda_write_bulk_callback(struct urb *urb)


