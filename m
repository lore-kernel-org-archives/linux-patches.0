Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49CB2EAD10;
	Fri,  9 Jan 2026 12:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960720; cv=none; b=ReFXm9tW/cQpW4lN2vtcRTZYi23tZa+AAcv9lMw71wZ+2TwfoDbbsUHjQUnOOeaGKJv1QxAQe7R7qyBy+ZtL3fKrw/Xqpaq9xdzn9hPrzZtKQc4Detnh8SKpYVabpaYarn1LexMdwJ9xa5jxroPe/6EGPtCkybCHANNdWb+4VgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960720; c=relaxed/simple;
	bh=b6HXfwhi8eNIg8I9jDRM/f+EBAK50OJ6t4Oi1Nr4c9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBFcTrnhY9PRGP3I5rwnzh0Uvx1PCefZ/+TDsmgFqiw7RQL54RElwprXH6emrjBOpmu9IW1bY6LAa7RpJ7eAMpQIRF8CIMkUDaLIVJJOtFS2SXlOxau9E1fTGCetR99oTLvTcrtCRiqY8JK3Z7Rcg2uphdbd+Oj6eqPYyjq6lYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0S12NKC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0S12NKC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D406C4CEF1;
	Fri,  9 Jan 2026 12:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960720;
	bh=b6HXfwhi8eNIg8I9jDRM/f+EBAK50OJ6t4Oi1Nr4c9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0S12NKC+Z9do7BKJjbSQWOO82DuzBidPHKSWe5+L8mCSg2akRw1mA8BmmBv5sNlNS
	 NqJDGJqPe4p6qgb8wYReOMBlmQD4qzT97pNp2cdzcObeKwXLPRkYuk3GKJKeOi53pn
	 DvGbIYNT2ZlqivgeXXh0biN5mGvC7Ikm1BQqIulk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.6 458/737] platform/chrome: cros_ec_ishtp: Fix UAF after unbinding driver
Date: Fri,  9 Jan 2026 12:39:57 +0100
Message-ID: <20260109112151.221459205@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 944edca81e7aea15f83cf9a13a6ab67f711e8abd upstream.

After unbinding the driver, another kthread `cros_ec_console_log_work`
is still accessing the device, resulting an UAF and crash.

The driver doesn't unregister the EC device in .remove() which should
shutdown sub-devices synchronously.  Fix it.

Fixes: 26a14267aff2 ("platform/chrome: Add ChromeOS EC ISHTP driver")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20251031033900.3577394-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_ishtp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/chrome/cros_ec_ishtp.c
+++ b/drivers/platform/chrome/cros_ec_ishtp.c
@@ -715,6 +715,7 @@ static void cros_ec_ishtp_remove(struct
 
 	cancel_work_sync(&client_data->work_ishtp_reset);
 	cancel_work_sync(&client_data->work_ec_evt);
+	cros_ec_unregister(client_data->ec_dev);
 	cros_ish_deinit(cros_ish_cl);
 	ishtp_put_device(cl_device);
 }


