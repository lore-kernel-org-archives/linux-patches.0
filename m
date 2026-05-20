Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA42B3E5A2F;
	Wed, 20 May 2026 11:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276023; cv=none; b=YaemlcNjD4vBQ57hwKmif77QX1dYQa6K+tq6TOAEo9R+V/0lRnA4zojQmU51plwOwPgFN0gm2I5e7lyX3f87ctG5eNHx6wPRUmFnfHvo1XHQlM76RRHSSWsUv8dcCg3uzy5/3faVaQ8k8zXJMfq47tq+Hxt1DWKWNpzrvs8sm1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276023; c=relaxed/simple;
	bh=jE/ap6AtQ4rLyz3VGPMSPdQOfMucbwTXULMeXJdwvuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XHK2J0675Tgn9PtFcRCzYJVxIup/03az0pS4DekUMbTpJ72wS8WKYgCcyGNpdxc6fzr06eO7smZyOVco1D7fFKuaI19jBQD3cURBDKWXHBisGONQHtihZE4ZhdjrUUyp4FKhnizra/ab+/kix2TnQTLSwQr8adBOj/7Ps4AZsMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/4weUHP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/4weUHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A561F0089B;
	Wed, 20 May 2026 11:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276020;
	bh=nc2srJMlOO6QkJcXkXpQ/gYgy6cnV+CHKhJGFqFNrqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/4weUHPpReSv0OB1ihrkk9lSXMsbhGY0y9ypctV25/gRlQrnpEzJx/D/mQGgOxdY
	 BV0R6aIOJukhEMHMGpDH52wPge/AulHOeFjKaW1gSWc4Ilv0xgUON6WaUH5Kg2mgtU
	 stJEX2RAXTwXVZEzQ897R882liCLDA7yp2b4v58dlyQqd1BR/i28XEGrtNHaI0LGX5
	 ssZJscbnc2tKlM+Rer6S6gk6wxHjUTJ7Eq1pCD1s4Py7fZs9DSJ3gT+0P6h46x9ipq
	 eMDuICF5914aUfsH9cJKq3s3SUYyjyy3vvlU3TE6SfVn4BF8RL9fJwkJOCtmUQ/tmM
	 JK3AGJk00cR8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Pradines <florian.pradines@gmail.com>,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	gupt21@gmail.com,
	jikos@kernel.org,
	bentiss@kernel.org,
	linux-i2c@vger.kernel.org,
	linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] HID: mcp2221: fix OOB write in mcp2221_raw_event()
Date: Wed, 20 May 2026 07:18:57 -0400
Message-ID: <20260520111944.3424570-25-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Transfer-Encoding: 8bit

From: Florian Pradines <florian.pradines@gmail.com>

[ Upstream commit f097d246677b03db814c5862f368cea341b76a00 ]

mcp2221_raw_event() copies device-supplied data into mcp->rxbuf at
offset rxbuf_idx without checking that the copy fits within the
destination buffer. A device responding with up to 60 bytes to a
small I2C/SMBus read can overflow the buffer.

Add a rxbuf_size field to struct mcp2221, set it alongside rxbuf in
mcp_i2c_smbus_read(), and check rxbuf_idx + data[3] <= rxbuf_size
before the memcpy.

Reported-by: Benoît Sevens <bsevens@google.com>
Signed-off-by: Florian Pradines <florian.pradines@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: subsystem `HID: mcp2221`; action verb `fix`; claimed
intent: prevent an out-of-bounds write in `mcp2221_raw_event()` when
copying device-supplied I2C read data into `mcp->rxbuf`.

Step 1.2 Record: tags found in upstream commit
`f097d246677b03db814c5862f368cea341b76a00`: `Reported-by: Benoît Sevens
<bsevens@google.com>`, `Signed-off-by: Florian Pradines
<florian.pradines@gmail.com>`, `Signed-off-by: Jiri Kosina
<jkosina@suse.com>`. No `Fixes:`, no `Cc: stable`, no `Link:` in the
commit message.

Step 1.3 Record: bug description is explicit: `mcp2221_raw_event()`
copies `data[3]` bytes into `mcp->rxbuf + rxbuf_idx` without checking
the destination buffer size. Failure mode is kernel memory corruption
via OOB write when a device returns up to 60 bytes for a smaller
requested read.

Step 1.4 Record: not hidden; this is a direct memory-safety fix.

## Phase 2: Diff Analysis
Step 2.1 Record: one file changed, `drivers/hid/hid-mcp2221.c`, 7
insertions. Modified areas: `struct mcp2221`, `mcp_i2c_smbus_read()`,
`mcp2221_raw_event()`. Scope: single-file surgical fix.

Step 2.2 Record: before, the driver tracked `rxbuf` and `rxbuf_idx` but
not the destination size. After, it stores `rxbuf_size` when setting
`rxbuf`, and rejects `rxbuf_idx + data[3] > rxbuf_size` before
`memcpy()`.

Step 2.3 Record: bug category is memory safety, specifically OOB write
from device-controlled length and cumulative receive offset. The earlier
`data[3] > 60` check only capped a single MCP2221 report, not the
destination buffer size.

Step 2.4 Record: fix is minimal and locally correct for the upstream
parent, but direct stable backports need care because older stable
branches still have two manual `mcp_smbus_xfer()` paths that set
`mcp->rxbuf` directly.

## Phase 3: Git History
Step 3.1 Record: `git blame` showed `rxbuf`, `rxbuf_idx`,
`mcp_i2c_smbus_read()`, and the `memcpy()` path originated in
`67a95c21463d0`, first contained in `v5.7-rc1`. The partial-read
handling came from `2682468671aa0`, first contained in `v6.8-rc1`. The
prior per-report `data[3] > 60` guard came from `b56cc41a3ae73`, first
contained in `v6.17-rc4` and backported to stable equivalents.

Step 3.2 Record: no `Fixes:` tag, so no tagged introducing commit to
follow.

Step 3.3 Record: recent related commits include `b56cc41a3ae73` for the
60-byte report cap, `e31b556c0ba21` for read-error cancellation, and
`ab05515757fcb` for using `mcp_i2c_smbus_read()` for block reads.
`ab05515757fcb` is an important context dependency for the exact
upstream diff.

Step 3.4 Record: author Florian Pradines had no other local commits
found in `drivers/hid`; Jiri Kosina, the HID maintainer,
committed/applied the patch.

Step 3.5 Record: upstream parent contains `ab05515757fcb`; stable
branches checked from `5.10.y` through `7.0.y` do not. A stable backport
should either adapt the patch to set `rxbuf_size` in the two remaining
manual `mcp_smbus_xfer()` paths or include an appropriate
prerequisite/backport.

## Phase 4: Mailing List / External Research
Step 4.1 Record: `b4 dig -c f097d246677b03db814c5862f368cea341b76a00`
found the lore thread: `https://patch.msgid.link/20260509094517.2691246-
1-florian.pradines@gmail.com`. `b4 dig -a` showed only v1.

Step 4.2 Record: `b4 dig -w` showed recipients included Florian
Pradines, Rishi Gupta, Jiri Kosina, Benjamin Tissoires, `linux-i2c`, and
`linux-input`.

Step 4.3 Record: reporter Benoît Sevens previously submitted a similar
heap-buffer-overflow patch. Jiri replied that Benoît’s patch was mangled
and that Florian’s patch would be taken with Benoît added as `Reported-
by`. Benoît then noted the missing `mcp_smbus_xfer()` assignments, which
is relevant for older stable bases.

Step 4.4 Record: not part of a multi-patch series. Related patches exist
for report-size validation, but Jiri questioned the “MCP2221 always
sends 64-byte reports” assumption in that separate thread.

Step 4.5 Record: direct lore/stable WebFetch was blocked by Anubis, but
web search found related stable discussion for prior mcp2221 fixes, not
an exact stable request for `f097d246677b`.

## Phase 5: Semantic Analysis
Step 5.1 Record: changed function is `mcp_i2c_smbus_read()`; changed
callback is `mcp2221_raw_event()`.

Step 5.2 Record: callers of `mcp_i2c_smbus_read()` are `mcp_i2c_xfer()`
and `mcp_smbus_xfer()`, wired into `mcp_i2c_algo`. `mcp2221_raw_event()`
is called from HID core before normal raw report processing, via
`hid_input_report()` / `__hid_input_report()`.

Step 5.3 Record: affected callees include `mcp_send_data_req_status()`,
`mcp_send_report()`, `wait_for_completion_timeout()`, and the vulnerable
`memcpy()`.

Step 5.4 Record: reachability is real: USB HID interrupt input reaches
`mcp2221_raw_event()`, and I2C/SMBus transfers reach
`mcp_i2c_smbus_read()` through the registered I2C adapter.
Triggerability by an unprivileged local user was not verified; trigger
by a malicious or buggy MCP2221-side device response is verified by the
code path.

Step 5.5 Record: similar pattern found in stable branches: two manual
`mcp_smbus_xfer()` receive-buffer assignments remain in stable branches
and must be handled in backports.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: the driver was introduced in `v5.7-rc1`; local stable
refs `5.10.y`, `5.15.y`, `6.1.y`, `6.6.y`, `6.12.y`, `6.18.y`, `6.19.y`,
and `7.0.y` contain the vulnerable `rxbuf`/`memcpy()` pattern. `5.4.y`
does not contain the driver.

Step 6.2 Record: `git apply --check` against current
`stable/linux-7.0.y` succeeds syntactically, but semantic backport work
is needed because stable lacks `ab05515757fcb`.

Step 6.3 Record: prior stable branches already contain the earlier
60-byte cap fix or its backported equivalent, but that does not fix
cumulative overflow into smaller destination buffers.

## Phase 7: Subsystem Context
Step 7.1 Record: subsystem is HID driver for the Microchip MCP2221 USB-
to-I2C/SMBus bridge. Criticality: driver-specific, but memory corruption
from USB/HID device input is high severity for affected systems.

Step 7.2 Record: file history shows active recent maintenance and
multiple security/correctness fixes in this driver.

## Phase 8: Impact And Risk
Step 8.1 Record: affected population is users of MCP2221 hardware or
systems exposed to such USB HID devices.

Step 8.2 Record: trigger is an I2C/SMBus read where the MCP2221-side
response reports more bytes than the destination buffer can hold.
Physical/malicious-device trigger is verified; unprivileged local
trigger depends on device-node permissions and was not verified.

Step 8.3 Record: failure mode is OOB write into kernel memory, severity
HIGH to CRITICAL due to memory corruption/crash/security risk.

Step 8.4 Record: benefit is high. Risk is low for the upstream parent
and for correctly adapted stable backports. Risk is medium for blind
cherry-picks into older stable branches because `rxbuf_size` would not
be set in all stable receive-buffer paths.

## Phase 9: Final Synthesis
Evidence for backporting: real OOB write, explicit reporter, small
patch, maintainer-applied, affects stable-supported code since `5.10.y`,
fixes a memory-corruption class bug.

Evidence against or concerns: no `Fixes:`/`Cc: stable`; exact upstream
diff assumes `ab05515757fcb`, absent from checked stable branches; blind
cherry-pick is not sufficient for older stable trees.

Stable rules checklist: obviously correct on its upstream base: yes.
Fixes a real user-affecting bug: yes. Important issue: yes, kernel
memory corruption. Small and contained: yes, 7 insertions. No new
feature/API: yes. Applies to stable: syntactically yes on `7.0.y`, but
older stable needs a branch-specific backport adjustment.

Exception category: none; this is a memory-safety fix, not a device
ID/quirk/doc/build exception.

## Verification
- Phase 1: fetched and inspected upstream commit
  `f097d246677b03db814c5862f368cea341b76a00`.
- Phase 2: verified exact diff is 7 insertions in `drivers/hid/hid-
  mcp2221.c`.
- Phase 3: ran `git blame`, `git describe --contains`, and targeted `git
  log` without `--all`; identified `67a95c21463d0`, `2682468671aa0`,
  `b56cc41a3ae73`, and `ab05515757fcb`.
- Phase 4: ran `b4 dig -c`, `b4 dig -a`, `b4 dig -w`, and fetched mboxes
  with `b4 mbox`; verified Jiri’s “Applied, thanks” and Benoît’s earlier
  report/backport-relevant concern.
- Phase 5: used code search and file reads to verify HID and I2C/SMBus
  call paths.
- Phase 6: used `git grep` against stable refs to verify vulnerable
  patterns in `5.10.y` through `7.0.y`, and absence from `5.4.y`.
- Phase 6: verified exact patch syntactically applies to current
  `stable/linux-7.0.y`, but `ab05515757fcb` is not an ancestor of
  checked stable refs.
- Phase 8: severity is based on verified device-controlled `memcpy()`
  into kernel buffer without destination-size check.
- UNVERIFIED: no runtime reproducer was executed; no build test was run;
  unprivileged local triggerability was not verified.

This should be backported, but stable maintainers should not blindly
cherry-pick it into pre-`ab05515757fcb` trees without adding
`rxbuf_size` initialization to every remaining `mcp->rxbuf` assignment.

**YES**

 drivers/hid/hid-mcp2221.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index ef3b5c77c38e3..badd4958bc12c 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -121,6 +121,7 @@ struct mcp2221 {
 	u8 *rxbuf;
 	u8 txbuf[64];
 	int rxbuf_idx;
+	int rxbuf_size;
 	int status;
 	u8 cur_i2c_clk_div;
 	struct gpio_chip *gc;
@@ -323,12 +324,14 @@ static int mcp_i2c_smbus_read(struct mcp2221 *mcp,
 		mcp->txbuf[3] = (u8)(msg->addr << 1);
 		total_len = msg->len;
 		mcp->rxbuf = msg->buf;
+		mcp->rxbuf_size = msg->len;
 	} else {
 		mcp->txbuf[1] = smbus_len;
 		mcp->txbuf[2] = 0;
 		mcp->txbuf[3] = (u8)(smbus_addr << 1);
 		total_len = smbus_len;
 		mcp->rxbuf = smbus_buf;
+		mcp->rxbuf_size = smbus_len;
 	}
 
 	ret = mcp_send_data_req_status(mcp, mcp->txbuf, 4);
@@ -912,6 +915,10 @@ static int mcp2221_raw_event(struct hid_device *hdev,
 					mcp->status = -EINVAL;
 					break;
 				}
+				if (mcp->rxbuf_idx + data[3] > mcp->rxbuf_size) {
+					mcp->status = -EINVAL;
+					break;
+				}
 				buf = mcp->rxbuf;
 				memcpy(&buf[mcp->rxbuf_idx], &data[4], data[3]);
 				mcp->rxbuf_idx = mcp->rxbuf_idx + data[3];
-- 
2.53.0

