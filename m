Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E8B223708;
	Tue, 21 Jul 2026 17:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654818; cv=none; b=RuAokJU9eS7SuOlBHJtwuc3/glq2tmOHI1TsD6ImwKy+YGNkrQVgn/Ps5fE7HeCePhX2+ykldiF0obnYYZTyz/tpB3N637Xp49vvLzNAHbUuWSlvN2gniAp9bXG15VIsuaPJ0IUDotWDvyGo05WWOmWFhKQb3WtnxcZkAEHtt/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654818; c=relaxed/simple;
	bh=I+ZtzyMEBcvXS4VaYEaILyoGbLKvdqZVNJKtotnXclM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ax2/M6hdB3Vj8kwLDeWSGjidKJhTEQfZKOh+ZYn/29Zvtuw3zVExDUq/nDfjnMpJaIUf7bhIai9wcsySORz0VPefJWdPjT+0O1BuQn4cJ+aASQI2hqI1AG/+fQIndJQGRxrtPrwKeS72bNyCTCP6S9RZsqZnlMXP2d+DNh1A6L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O70VVP6b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O70VVP6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8DE1F000E9;
	Tue, 21 Jul 2026 17:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654817;
	bh=tC/qq9Vr87I8oD/n+8TBoXUEzM/ljsXoew0Xq6V4XLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O70VVP6b2FBSmmFjVDxNuHTWW4szuMGjbXmLbbz+A3+c8FPa11YWkmTnKVkflY6wb
	 wATFxlhRfgMW45ZQF72376FHv9csKq1xq5j/IPkWv7AzEFltByb8VcBdiJ/V/QrhN6
	 5N91i78G5/Y8tA1QowbRCDIgUqNZ3SMi08Wm9Z9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.1 1806/2077] tpm: fix event_size output in tpm1_binary_bios_measurements_show
Date: Tue, 21 Jul 2026 17:24:39 +0200
Message-ID: <20260721152635.344928900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 1a58f6115bfb34eabcc7de8a3a9745b219179781 upstream.

Commit 186d124f07da ("tpm_eventlog.c: fix binary_bios_measurements")
split the output to write the endian-converted event header first and
then the variable-length event data.

However, the split was at sizeof(struct tcpa_event) - 1, even though
event_data was a zero-length array, and later a flexible array member,
both of which already excluded the event data.

Therefore, the current code writes the first three bytes of event_size
from the endian-converted header and then the last byte from the raw
header, which can emit a corrupted event_size on PPC64, where
do_endian_conversion() maps to be32_to_cpu().

Split one byte later to write the full endian-converted header first,
followed by the variable-length event->event_data.

Fixes: 186d124f07da ("tpm_eventlog.c: fix binary_bios_measurements")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/eventlog/tpm1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/tpm/eventlog/tpm1.c
+++ b/drivers/char/tpm/eventlog/tpm1.c
@@ -236,12 +236,12 @@ static int tpm1_binary_bios_measurements
 
 	temp_ptr = (char *) &temp_event;
 
-	for (i = 0; i < (sizeof(struct tcpa_event) - 1) ; i++)
+	for (i = 0; i < sizeof(struct tcpa_event); i++)
 		seq_putc(m, temp_ptr[i]);
 
 	temp_ptr = (char *) v;
 
-	for (i = (sizeof(struct tcpa_event) - 1);
+	for (i = sizeof(struct tcpa_event);
 	     i < (sizeof(struct tcpa_event) + temp_event.event_size); i++)
 		seq_putc(m, temp_ptr[i]);
 


