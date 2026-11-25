Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623147;
	b=IRzvHXvYzyporCAUS5lRvpXp6WuzqWQ97tW1tl1h2mqo+CBGGs7gdvqi80Yn1FCVc/SE
	 kI0eavuEUW6LsIaNBKcm6NrgFMYTuOCl+HnzDcFwN5aVh7zSmum71OYfWPruTKqZ0qkCU
	 orw6rN9V4+pKJOTU1ZpwyXBgUYEYKB8Nr3vcR3QuXFL6DNF0M/SD2/jaVhs2fsehfkV5y
	 //7expcq++HhVLwolufM2a0QOtX/SL1mU6cFFKS2ZebNbrXJoZnO+jBOgp97qIf5NCufv
	 RlcyoKzchZP9iQI9Fg+FP1Rg1E+AVCgQP/6YqBaR7QMa5Od1aynGD70HbDJaNZ/o7eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aCXM2hzVhm/tjUWt6rfsFZUGvXNHGxnE9GjTqlISPjI=;
	b=u8+VkF6ze4VXbqM6DqoPrzEUhngtiDZm9ON+SaGWQWeJQWKx5vX+vK3cc9LGGygEHnw2
	 MUy7TSVbyBjSmh/5IRwrQCG7P0Ieaebq1ACOA0UdWavOA7ZH3itYqd0AUMokp8IGxKgwy
	 lN9UWEb18MGVk+wGSaWGvqj+EFoEBLPWYE456RK6iGOyJyy/uY72Bo9c2q3Iv4TQbvbL8
	 DpsYOPTYxvk304dPtcoxaJg1RvXTw/Sj25RKd9i/+6qfZlGxKLA6rIloZEOj7l1SKgMRm
	 pHbdEzTTTyYM/kMP1kMLwGFrUB0XzhRrw+8j3rUUpgjzx3BBbVCZsEuiIoGmD+anK3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HWy99EeA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EA9606A323;
	Wed, 25 Nov 2026 16:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HWy99EeA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627041F000C0;
	Wed, 25 Nov 2026 16:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623146;
	bh=aCXM2hzVhm/tjUWt6rfsFZUGvXNHGxnE9GjTqlISPjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWy99EeARvWjMZqtBgpSr2+BSnwBdb1RrOtd9wuKtNgcj1A2Lsa5yeQFeBFBnOV0l
	 TnFKqyKkvi92xNhfGLYtWqBLXISwyk4jDkviL+CN3TKK188nwcEAMKDg7XhbTmJxiw
	 DoIVp60u3wacUjYJaSwU0Ciyokf6xSgDPOg6BqO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 765/990] tpm: eventlog: check the payload size before reading tag events
Date: Wed, 25 Nov 2026 15:35:32 +0100
Message-ID: <20261125143839.973448204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


