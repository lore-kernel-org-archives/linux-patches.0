Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC79226D00;
	Sat, 14 Feb 2026 01:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031202; cv=none; b=gW5od731IEe6U3yc6dtu5CL7WlyCUxNZtDhsmBW6xIGZuE4dJMx0rXyU3X/pmlyxhnjOKx5eUcJFbp/GnLn+DaEIKYfLu5FavdF01o1/gdb2JwP9jGsdiyHBqYGj2G6c8PvZXY/H37yYcz8yATowOD8Bv9TXaWbChulx1nMQ1Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031202; c=relaxed/simple;
	bh=NfqMjKl3LU+/h/kCR0/KNm37DV0k9OWuTAvYkbKbcmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qe2hX5zhqSet++wxo61r/FIZ7LiLDZO3VVJDxkA1hhg+fiBikuH/hGFEBsjWDUmpA37l3nCtq3DriK4OAU1vwYpZbpCX/IsJmLDOu5PFBXBKTiiTNvhYS3hqBq9d19dTqh5X2Q0Zqb+jtBvlcyYGlClqcgfr/pPUnQimt/+Syj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzSvC8/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzSvC8/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242BCC116C6;
	Sat, 14 Feb 2026 01:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031202;
	bh=NfqMjKl3LU+/h/kCR0/KNm37DV0k9OWuTAvYkbKbcmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzSvC8/ULfZDUUBLI8EmUvVngMhgTeOwWMcYnchB/MAZBRZRySw8S2/OhOp97nTWp
	 ramkWC5q+ldh6QiKqgkEZXIVUk5/bvUHIGPHXWArXrtVt1RyarxD1T7x1VXHtUZK/7
	 F2YVGvEhEL0fojvf5QcqJHpTvWkUR/HkdOl1aPIC/9mgNlXZUB2UQ9SZW6W2x/igZ+
	 wGQ8BDJE2fgbSCuBP75/LKM5y4So4Ozz433gUZNmgPWmycIk5/AVrNPsy0GcTGMKh/
	 0y8sNzLjWJFTPvRPQk+SbE7TuxOo8T3wEnZCTd5h8SSITpiiKHbt1WtsMKqnL6YOtU
	 6V5dB4JXzZIPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	daniel.baluta@nxp.com,
	sound-open-firmware@alsa-project.org
Subject: [PATCH AUTOSEL 6.19-6.12] ASoC: SOF: ipc4: Support for sending payload along with LARGE_CONFIG_GET
Date: Fri, 13 Feb 2026 19:59:41 -0500
Message-ID: <20260214010245.3671907-101-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit d96cb0b86d6e8bbbbfa425771606f6c1aebc318e ]

There are message types when we would need to send a payload along with
the LARGE_CONFIG_GET message to provide information to the firmware on
what data is requested.
Such cases are the ALSA Kcontrol related messages when the high level
param_id tells only the type of the control, but the ID/index of the exact
control is specified in the payload area.

The caller must place the payload for TX before calling the set_get_data()
and this payload will be sent alongside with the message to the firmware.

The data area will be overwritten by the received data from firmware.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20251217143945.2667-7-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete understanding. Here's my analysis:

---

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

The subject is "ASoC: SOF: ipc4: Support for sending payload along with
LARGE_CONFIG_GET". The commit message says:

> "There are message types when we would need to send a payload along
with the LARGE_CONFIG_GET message to provide information to the firmware
on what data is requested."

The specific case it mentions is for ALSA Kcontrol-related messages
where the `param_id` only tells the type of control (switch or enum),
but the **ID/index of the exact control is specified in the payload
area**. Without this patch, the firmware **cannot know which control**
is being queried.

The message also says: "The data area will be overwritten by the
received data from firmware." This explains the `kmemdup` approach — the
TX payload needs to be saved before it's overwritten by the RX response.

### 2. CODE CHANGE ANALYSIS

**The Bug:**

In `sof_ipc4_refresh_generic_control()` (in `ipc4-control.c`, line
243-285), the caller:
1. Allocates `sof_ipc4_control_msg_payload`
2. Sets `data->id = cdata->index` and `data->num_elems =
   scontrol->num_channels`
3. Points `msg->data_ptr = data` and `msg->data_size = data_size`
4. Calls `sof_ipc4_set_get_kcontrol_data(scontrol, false, true)`
   (set=false → GET operation)

This flows into `sof_ipc4_set_get_data()`. In the **old code** (before
this patch), when `set=false` (GET), the code did:

```c
tx_size = 0;
rx_size = chunk_size;
```

This means `tx_size = 0` — **the payload containing `id` and `num_elems`
is NEVER sent to the firmware**. The firmware receives a
LARGE_CONFIG_GET request without knowing which specific switch/enum
control is being queried. For switch and enum controls (param_ids 200
and 201), the param_id alone is not enough — the firmware needs the
control ID in the payload to know which specific control to return data
for.

**The Fix:**

The patch adds a helper function `sof_ipc4_tx_payload_for_get_data()`
that checks if the message is for switch or enum controls (param_id 200
or 201). If so, it:

1. Uses `kmemdup()` to save the TX payload (because `data_ptr` will be
   overwritten by the response)
2. Sets `tx_size` and `tx.data_ptr` in the GET path so the payload IS
   sent
3. Properly frees the backup buffer on all code paths (error and
   success)

**What happens without the fix:**
When firmware sends a notification that a switch/enum control changed,
the `comp_data_dirty` flag is set. On the next `sof_ipc4_switch_get()`
or `sof_ipc4_enum_get()` call, `sof_ipc4_refresh_generic_control()`
tries to fetch the new control values from firmware, but **fails**
because the firmware can't identify which control to return data for (it
receives no payload with the GET request). This means ALSA mixer
applications (like `alsamixer`, PulseAudio/PipeWire) get **wrong or
stale control values** — a functional bug for real audio users.

### 3. CLASSIFICATION

This is a **functional bug fix**. Without it, reading switch/enum
kcontrol values from SOF firmware after a notification fails to return
correct data. The commit message frames it as "support for" but it is
really fixing broken functionality — the
`sof_ipc4_refresh_generic_control` function was already calling
`set_get_data` with a payload expecting it to be sent, but the lower
layer was silently discarding it.

It is NOT a new feature — the switch/enum control GET path already
exists (since v6.7). The payload was already being prepared by the
caller. The bug is that the IPC layer was not transmitting it.

### 4. SCOPE AND RISK ASSESSMENT

- **Files changed:** 1 (`sound/soc/sof/ipc4.c`)
- **Lines added:** ~50 (new helper function + modifications to existing
  function)
- **Complexity:** Moderate — adds a `kmemdup`/`kfree` for specific
  param_ids
- **Risk:** Low — the change only affects the GET path for switch/enum
  controls (param_ids 200, 201). All other GET operations continue to
  behave exactly as before (`sof_ipc4_tx_payload_for_get_data` returns
  false, no change in behavior).
- **Memory management:** The `kmemdup` buffer is properly freed on all
  paths (early error return, normal exit).
- **Self-contained:** Yes, the patch only modifies `ipc4.c` and adds an
  include for constants that already exist in the tree.

### 5. USER IMPACT

- **Who is affected:** All Intel SOF audio users with switch or enum
  kcontrols that receive firmware notifications (this is common for
  hardware-managed controls on modern Intel platforms like Meteor Lake
  and newer).
- **Symptom:** ALSA kcontrols report stale/wrong values after firmware
  changes them (e.g., mic privacy hardware switches, audio routing
  enums).
- **Severity:** Medium-high — incorrect audio control states affect real
  audio functionality.

### 6. STABILITY INDICATORS

- **4 Reviewed-by tags** from Intel SOF team members (Seppo Ingalsuo,
  Ranjani Sridharan, Bard Liao, Kai Vehmanen)
- **Accepted by Mark Brown** (ASoC subsystem maintainer)
- **Author is subsystem maintainer** (Peter Ujfalusi is a SOF
  maintainer)

### 7. DEPENDENCY CHECK

- Requires `SOF_IPC4_SWITCH_CONTROL_PARAM_ID` and
  `SOF_IPC4_ENUM_CONTROL_PARAM_ID` from `ipc4-topology.h` — these were
  added in v6.7 (commit `4a2fd607b7ca`)
- Requires `sof_ipc4_refresh_generic_control` which was added in v6.8
  (commit `f5eb9945cf9c`)
- The patch adds `#include "ipc4-topology.h"` to ipc4.c — this is a
  trivial include addition
- The `SOF_IPC4_MOD_EXT_MSG_PARAM_ID_MASK` is in
  `include/sound/sof/ipc4/header.h` (available in all relevant stable
  trees)
- **Self-contained:** The patch applies cleanly without other
  dependencies beyond what's already in stable trees ≥6.7

### 8. CONCERNS

- This is part of a larger patch series (patch 7 of N), but examining
  the code shows it is **self-contained** — it modifies only
  `sof_ipc4_set_get_data()` in `ipc4.c`, not the callers
- The commit message says "Support for sending payload" which sounds
  like a feature, but the analysis shows it's fixing an existing broken
  GET path for switch/enum controls
- The `sof_ipc4_tx_payload_for_get_data` helper uses a switch statement
  that currently only matches 2 param_ids — if future param_ids need
  this treatment, they'd need to be added, but that's expected for an
  explicitly enumerated list

### CONCLUSION

This commit fixes a real functional bug where ALSA switch and enum
kcontrol GET operations from SOF firmware fail to send the required
payload (control ID/index) to the firmware, causing the firmware to not
know which control is being queried. This results in incorrect/stale
control values being reported to userspace audio applications. The fix
is small (~50 lines in one file), self-contained, well-reviewed by 4
domain experts, low-risk (only affects 2 specific param_ids in the GET
path), and fixes a real user-visible audio issue. It applies cleanly to
stable trees v6.7+.

However, the critical concern is that this is labeled as "patch 7" of a
series, and the remaining patches in the series likely depend on this
behavior. Without knowing if the other patches add callers that depend
on this, the standalone value is limited to fixing
`sof_ipc4_refresh_generic_control()` which was already sending payloads
that were being silently dropped. The existing caller
(`sof_ipc4_refresh_generic_control`) does set `data->id` and
`data->num_elems` before calling the GET, expecting it to be sent — so
this IS fixing existing broken functionality, not just enabling future
functionality.

The fix addresses a real bug for SOF audio users and meets stable
criteria.

**YES**

 sound/soc/sof/ipc4.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4.c b/sound/soc/sof/ipc4.c
index a4a090e6724a6..20d723f48fff0 100644
--- a/sound/soc/sof/ipc4.c
+++ b/sound/soc/sof/ipc4.c
@@ -15,6 +15,7 @@
 #include "sof-audio.h"
 #include "ipc4-fw-reg.h"
 #include "ipc4-priv.h"
+#include "ipc4-topology.h"
 #include "ipc4-telemetry.h"
 #include "ops.h"
 
@@ -433,6 +434,23 @@ static int sof_ipc4_tx_msg(struct snd_sof_dev *sdev, void *msg_data, size_t msg_
 	return ret;
 }
 
+static bool sof_ipc4_tx_payload_for_get_data(struct sof_ipc4_msg *tx)
+{
+	/*
+	 * Messages that require TX payload with LARGE_CONFIG_GET.
+	 * The TX payload is placed into the IPC message data section by caller,
+	 * which needs to be copied to temporary buffer since the received data
+	 * will overwrite it.
+	 */
+	switch (tx->extension & SOF_IPC4_MOD_EXT_MSG_PARAM_ID_MASK) {
+	case SOF_IPC4_MOD_EXT_MSG_PARAM_ID(SOF_IPC4_SWITCH_CONTROL_PARAM_ID):
+	case SOF_IPC4_MOD_EXT_MSG_PARAM_ID(SOF_IPC4_ENUM_CONTROL_PARAM_ID):
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 				 size_t payload_bytes, bool set)
 {
@@ -444,6 +462,8 @@ static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 	struct sof_ipc4_msg tx = {{ 0 }};
 	struct sof_ipc4_msg rx = {{ 0 }};
 	size_t remaining = payload_bytes;
+	void *tx_payload_for_get = NULL;
+	size_t tx_data_size = 0;
 	size_t offset = 0;
 	size_t chunk_size;
 	int ret;
@@ -469,10 +489,20 @@ static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 
 	tx.extension |= SOF_IPC4_MOD_EXT_MSG_FIRST_BLOCK(1);
 
+	if (sof_ipc4_tx_payload_for_get_data(&tx)) {
+		tx_data_size = min(ipc4_msg->data_size, payload_limit);
+		tx_payload_for_get = kmemdup(ipc4_msg->data_ptr, tx_data_size,
+					     GFP_KERNEL);
+		if (!tx_payload_for_get)
+			return -ENOMEM;
+	}
+
 	/* ensure the DSP is in D0i0 before sending IPC */
 	ret = snd_sof_dsp_set_power_state(sdev, &target_state);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(tx_payload_for_get);
 		return ret;
+	}
 
 	/* Serialise IPC TX */
 	mutex_lock(&sdev->ipc->tx_mutex);
@@ -506,7 +536,15 @@ static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 			rx.data_size = chunk_size;
 			rx.data_ptr = ipc4_msg->data_ptr + offset;
 
-			tx_size = 0;
+			if (tx_payload_for_get) {
+				tx_size = tx_data_size;
+				tx.data_size = tx_size;
+				tx.data_ptr = tx_payload_for_get;
+			} else {
+				tx_size = 0;
+				tx.data_size = 0;
+				tx.data_ptr = NULL;
+			}
 			rx_size = chunk_size;
 		}
 
@@ -553,6 +591,8 @@ static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 
 	mutex_unlock(&sdev->ipc->tx_mutex);
 
+	kfree(tx_payload_for_get);
+
 	return ret;
 }
 
-- 
2.51.0

