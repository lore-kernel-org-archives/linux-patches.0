Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B246415F10;
	Tue, 21 Jul 2026 22:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674367; cv=none; b=XuIa3xec1SvFyRQqjGqMWuOmt7b+LdevHIMQu4exyrgRPgWMSbFLTz3zOt9eUea2iokKbCDlE/9f7dlib3PqmMUIOyqJ3adTvDzQIdPH/Z8iJCYzDuuSmBR329WTkeYrmozQouhS0ojQYGEqms1u2AmL6BlmY0zBw2XIXrp5kT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674367; c=relaxed/simple;
	bh=ih7dEx5nS4JrQpdf9sF63La1tErc9Cyx8+08M2jaLBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VyiPEWwgDsBennmthc+LdUtrucP0ZT0MGbneGEX5c1de8PvK1mUK3c7siLVGaqYRck4JIQ0UkVFVtcP91+mXmD5k7dDbR7D0sMod5BxN1m9LPCfS9TSnABOJh1TJRpoMjufVt/5YJZR2j0XgZBmNg4TnOAmNi4VW6ckGWVkvSaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNJtjidM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNJtjidM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F331F000E9;
	Tue, 21 Jul 2026 22:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674365;
	bh=e81gFG62dLGKCsy7VWOrAhjZ84OvF2DGVrz8wIiAYYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNJtjidMUhe5cQVlrgI1E2hx8uhf1hJOD0gR8OXar+/TZcIpchtgAyaP60Y23UhD+
	 fESqbgxh8hg2n6nwQvGeGyXSlsPAIIt4DJY4ImuAocsUls2p+NhV0Qmpgg9z0/clq/
	 Pn9URnXH6nQ2ErDHuED/lIIdHBFTgmAnfC0wc+ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 497/699] tpm: fix event_size output in tpm1_binary_bios_measurements_show
Date: Tue, 21 Jul 2026 17:24:16 +0200
Message-ID: <20260721152406.904625343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -235,12 +235,12 @@ static int tpm1_binary_bios_measurements
 
 	temp_ptr = (char *) &temp_event;
 
-	for (i = 0; i < (sizeof(struct tcpa_event) - 1) ; i++)
+	for (i = 0; i < sizeof(struct tcpa_event); i++)
 		seq_putc(m, temp_ptr[i]);
 
 	temp_ptr = (char *) v;
 
-	for (i = (sizeof(struct tcpa_event) - 1);
+	for (i = sizeof(struct tcpa_event);
 	     i < (sizeof(struct tcpa_event) + temp_event.event_size); i++)
 		seq_putc(m, temp_ptr[i]);
 


