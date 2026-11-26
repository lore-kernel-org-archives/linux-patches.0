Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704591;
	b=OgGLyDHg1n9f/shPAnA4+IDpFl2HSgOGQeXVj0buoRCSBLVG9KSp1rD+2KbRX39Y8icm
	 6hclmK/acRJZ+jpv9SLCvcXQa4geh5mXkYX07xCJQkuI8uEqzSJ4rohXYCXbTyabGdkuF
	 6aJwislLWGM8PYwDqYUilb9A/7v/D7TYqDzDl5X9bl13zm5tCJphoRCmPSuVpVCSvCjBm
	 FlREi0/iTI8GmDGwVLu1j3Xeu7ge8cRewSwThNm0fgJt0mz/sbqMFyBm9uG78DxFXcMyF
	 bdgJyjBf79BGRGR0vuV+/w/iSj+FFWQPjH6flduNvw7yyTbJKoghtRjayu3ZX73Qigw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m/dBt7Mo8Q281DMvo51UwpeKRywRNAGJTuWgBu5XKYU=;
	b=Wg3mdS2yJHSz5eTt+6r8x006G6rY4tvM2S24sHQo25pq97e/6djeMPSliB0FaTTP1g3Q
	 FQQV49JvhMuSNDJ93rg5q9fp6wRkbLjSwk5pNdRH47TOQgwS0DmS3L03BOR+eY/MZnuyf
	 Qdvw/FvSWkRxLERom/6t2YEiBjxYWTNuzeWgJvBSCnfK0n5r7w+Nrhtzu9ljZUA60hfG6
	 s/nJBLcKzibD4DYB7mII44oWfgakhfd+NLkwgnG6ZgjL6sOgdbSqffAGVBSKn/XPq1V7X
	 dUX8b5YRDfPCfqpkiGImAdq0SkuPOsH2NHUGQ2cYC74Ujlo58vLM/m/sCxHSXxDwnyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J/CLBocm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97761606A31C;
	Thu, 26 Nov 2026 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J/CLBocm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1841F000CA;
	Thu, 26 Nov 2026 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704591;
	bh=m/dBt7Mo8Q281DMvo51UwpeKRywRNAGJTuWgBu5XKYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/CLBocmMvYdTAk5yioBsiyNnkuH6z5O/lrpwpUivC/m7n7lfa/0nvM/MyGT+kVje
	 ZGAMoapiazerop0QecDlo4EbciLLKbxfPy1Tx5nNTbbVuraTsvei3fZe7ZXc8qZYXI
	 Gc8fef5m90GJwzj3WnVjm1/3bT5r902YTmPXj/eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 176/265] tpm: eventlog: check the payload size before reading tag events
Date: Thu, 26 Nov 2026 15:38:26 +0100
Message-ID: <20261126143617.473561971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


