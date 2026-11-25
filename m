Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625779;
	b=UF9HBFYLskf96FzCGy2QhQvymXUeHQU1EdrXvpJ6euOWpJFoqasMnFGLgtSIobHTgkfT
	 l6Q4wWVZxdTUIrEi2ufiZOUb6Q/Vv4Lf6iBmBaR/6SIyTl/rQjTRqgLI75PpENiR4ARti
	 PQEsf43GAV6m3lsmCqMBIuSKKWTyeRXbDzn+qkVCtZtmOM77gSpJDp9Bb9bfktc4qO7JN
	 U4LG6rEcN65hh6C4YG35rGrHxq7w9Cy8/nYfWY2VYAMdIcJAnNmVaQNMNIOkpJONhgwrQ
	 +cFRWCLYnIBrl4yTMW43nI0g+0lMojNcWdcWaRji2Nd9QIG0CqmWJJdF9wN0PSxcszA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9dABaJaDLlIOK6ZPbI/x0a04somw4iJWuaSkuw3AT20=;
	b=W/TUEyZ0FxLFLkjuybsFODOzjPBYPT3yk+YqQOraDXPZKY5OuYrQZmask0G0gptjQy+b
	 brIAxH8Y3BANng8cTWtD9l1H1UemlmUVf3eRv5gOVTFaXgVI/lozxnSBnxwIr7JKy9y4b
	 hhim9CcSpqg4bupebz7ixv5qm/gaGgMsTOBHEBCvLBE7DFStOnbnR+Q48BGnP0903v4Ya
	 4TO3nv/cH48vjPt53dKA7YoxKA4uKQ0HWJX0IZ6ot01Tb0X/Cx8Ki/Oix+AVOCStGVtkI
	 z8a/WYBWxoFkSRZbxwl2YS+gaunafkledAcW+r39awU/AWlBCWpvzeswXLdeX1l6qag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TESIUCt1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290F4606A693;
	Wed, 25 Nov 2026 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TESIUCt1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DB11F01570;
	Wed, 25 Nov 2026 16:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625779;
	bh=9dABaJaDLlIOK6ZPbI/x0a04somw4iJWuaSkuw3AT20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TESIUCt1koY7wc8lOweqzUL1EiSyqf/kw5UuBpNprh34Mh8fTJ8Bsr9Vunnpqc8bK
	 keH+xo4moqwdi/rAGmESqzy8xFxIO6CkSC8bOjUWBBR4eB07AAVj0EjKKixB14Azva
	 CYztBxE3uLeyMpkJt5Z4km5duuVuk2kLrzj+XEc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 629/816] tpm: eventlog: check the payload size before reading tag events
Date: Wed, 25 Nov 2026 15:36:17 +0100
Message-ID: <20261125143903.744654026@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanglei Zhu <zhugl3@xiaopeng.com>

commit 0a385f668ba77d29ae167c1668fd452418ebc9d6 upstream.

The EVENT_TAG branch of get_event_name() casts the event payload to
struct tcpa_pc_event and reads from it:

	pc_event = (struct tcpa_pc_event *)event_entry;

	switch (do_endian_conversion(pc_event->event_id)) {
	...
		for (i = 0; i < 20; i++)
			d_len += sprintf(&data[2*i], "%02x",
					pc_event->event_data[i]);

The log iterators only verify that the event header plus the declared
event_size stays within the log buffer; they do not require the
payload of an EVENT_TAG entry to be large enough for the fields the
branch reads. A truncated entry makes the branch read up to 20 bytes
of event_data[] past the end of the entry, and, for the last entry in
the log, past the end of the buffer itself.

The legacy PC Client spec defines the EV_EVENT_TAG payload as a
TCPA_PC_EVENT - event_id, event_size and event-type-specific data -
so a conformant entry carries the 8-byte header and the hash-type
ids carry a full digest. The log itself, however, is an ACPI table
the firmware leaves in memory: the TPM never measures the log, so
the kernel cannot tell a conformant log from a corrupted one. The
iterators already work on that assumption - they stop once the
declared event_size runs past the buffer end - and the readers
should apply the same rule to what they take off the payload.

Skip entries whose payload cannot even hold the event id, and skip
the 20-byte digest dump when the payload cannot hold the full
tcpa_pc_event header plus the digest, so the branch never reads
beyond the entry it is formatting.

Cc: stable@vger.kernel.org
Fixes: 55a82ab3181b ("[PATCH] tpm: add bios measurement log")
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/eventlog/tpm1.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/char/tpm/eventlog/tpm1.c
+++ b/drivers/char/tpm/eventlog/tpm1.c
@@ -178,6 +178,10 @@ static int get_event_name(char *dest, st
 		}
 		break;
 	case EVENT_TAG:
+		if (do_endian_conversion(event->event_size) <
+		    sizeof(pc_event->event_id))
+			break;
+
 		pc_event = (struct tcpa_pc_event *)event_entry;
 
 		/* ToDo Row data -> Base64 */
@@ -203,6 +207,9 @@ static int get_event_name(char *dest, st
 			name = tcpa_pc_event_id_strings[do_endian_conversion
 							(pc_event->event_id)];
 			n_len = strlen(name);
+			if (do_endian_conversion(event->event_size) <
+			    sizeof(struct tcpa_pc_event) + 20)
+				break;
 			for (i = 0; i < 20; i++)
 				d_len += sprintf(&data[2*i], "%02x",
 						pc_event->event_data[i]);


