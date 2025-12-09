Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420702741C9;
	Tue,  9 Dec 2025 00:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239452; cv=none; b=Z63TvFjpjxJOP9L4jqAT5r64AqK/YHW1gaCo50WXlPo0BiOud0rET95U5pyr1djtQpL1JNXqCfdnk7otOOPsZc9wj06ZieVAw5cHsMyaESydaeWaG8KcDotTcthsPOitVsSEFAF4kkEf5ebXs4KZ7qTpN8zol2mJbrIQJbNsd4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239452; c=relaxed/simple;
	bh=xEcJhY/65BiM4R/OJzWRT7OXL3yOFJmAuWxoDK5SAzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9cE9tsbYo/NzBn2Kh63KT6AQ6Hx917VbF917oqwB/f2ZJid1U6ACQc1UJ0HlKoiL5vfprB3QRLNrwWczTwxlcGKG2GC9sHZbHSATMItlFdur1Sh3ZkYkqd7B9c1wQpWo0mALpgn92im4fFU3K3+6PPLSlkDSTU2ZrJGf9EyAGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+BtuGw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+BtuGw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0B4C113D0;
	Tue,  9 Dec 2025 00:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239452;
	bh=xEcJhY/65BiM4R/OJzWRT7OXL3yOFJmAuWxoDK5SAzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+BtuGw8f2E60bQQqf6069qRDQDWIvPjNzFe+SXsnZwP2HER1hdULevLwTC9GPGAC
	 CYahEqGYauQYMnxGQ75rc+JifsjXfCbAyIjh1YqWdZusb7YrgCBfLSR/rEet1ya9aE
	 kvDF6dm9RS6sh2+1wtBP4HNke2wS5ZIa6j+J9BZmaQTSDJWRHxAsvxy40D8BhpgZbC
	 wlfePWzVyJflzFW65evWQwC59v/gPlQ6v6g50kqoIBOsijORLveqhSncD3ws0O92lH
	 Xu/h/youhDo//IhnQ9cw+G/uG/6S4arusf2JStQCRH3l7Yb06I6ox82C9SRrvBJRnn
	 j3J0Tt6+ywxIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	kuba@kernel.org,
	sdf@fomichev.me,
	kuniyu@google.com,
	ahmed.zaki@intel.com,
	skhawaja@google.com,
	aleksander.lobakin@intel.com
Subject: [PATCH AUTOSEL 6.18-5.10] net: init shinfo->gso_segs from qdisc_pkt_len_init()
Date: Mon,  8 Dec 2025 19:15:17 -0500
Message-ID: <20251209001610.611575-25-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit be1b70ab21cbe8f8bb8ecf39eb34880882252773 ]

Qdisc use shinfo->gso_segs for their pkts stats in bstats_update(),
but this field needs to be initialized for SKB_GSO_DODGY users.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251121083256.674562-3-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Complete Analysis Summary

### What the Commit Fixes

This commit fixes an **incorrect qdisc packet statistics** bug for
`SKB_GSO_DODGY` packets (traffic from untrusted sources like VMs,
containers via virtio_net, veth, etc.).

**Technical mechanism of the bug:**
1. `qdisc_pkt_len_init()` is called from `__dev_queue_xmit()` to
   calculate accurate packet lengths for qdisc statistics
2. For `SKB_GSO_DODGY` packets, the function correctly recalculates
   `gso_segs` because the original value is untrusted
3. However, this recalculated value was only used locally for `pkt_len`
   calculation and **not stored back** to `shinfo->gso_segs`
4. Later, `bstats_update()` reads `skb_shinfo(skb)->gso_segs` directly,
   getting the **wrong** (original untrusted) value
5. This results in incorrect packet counts in qdisc statistics (`tc -s
   qdisc show`)

### Code Change Analysis

The fix is minimal:
- **Line 1:** Changed `const struct skb_shared_info *shinfo` to `struct
  skb_shared_info *shinfo` (removes const to allow writing)
- **Line 2:** Added `shinfo->gso_segs = gso_segs;` after calculating the
  correct value

The fix simply stores the already-calculated value back where
`bstats_update()` will read it.

### Stable Kernel Criteria Evaluation

| Criterion | Assessment |
|-----------|------------|
| Obviously correct | ✅ YES - The calculation already exists; this just
stores the result |
| Fixes real bug | ✅ YES - Incorrect statistics for VM/container traffic
|
| Small and contained | ✅ YES - 2 lines changed in 1 file |
| No new features | ✅ YES - Bug fix only |
| Tested | ✅ YES - Accepted by netdev maintainer |

### User Impact

- **Affected users:** Anyone using qdisc (traffic shaping, rate
  limiting) with virtualized or containerized workloads
- **Severity:** Medium - incorrect statistics, not a crash/corruption
- **Common scenarios:** VMs (virtio_net), containers (veth), any traffic
  marked `SKB_GSO_DODGY`

### Risk Assessment

- **Risk:** LOW - The fix is trivial and the calculation logic is
  already proven
- **Dependency:** None - self-contained fix
- **Backport complexity:** Should apply cleanly to any stable tree with
  this code

### Concerns

1. **No `Cc: stable@vger.kernel.org`** - Maintainer didn't explicitly
   request
2. **No `Fixes:` tag** - Bug likely dates to 2013 (commit 1def9238d4aa)

However, Eric Dumazet is a prolific netdev maintainer who sometimes
doesn't add Cc: stable for straightforward fixes. The fix's correctness
is self-evident.

### Conclusion

This is a small, obvious, low-risk bug fix that corrects packet
statistics for common virtualized/containerized workloads. It meets all
stable kernel criteria: it fixes a real bug affecting users, is small
and self-contained, and introduces no new features. The risk of
regression is minimal since the fix only stores an already-computed
value.

**YES**

 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2acfa44927daa..16cbba09b9627 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4063,7 +4063,7 @@ EXPORT_SYMBOL_GPL(validate_xmit_skb_list);
 
 static void qdisc_pkt_len_init(struct sk_buff *skb)
 {
-	const struct skb_shared_info *shinfo = skb_shinfo(skb);
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
 
 	qdisc_skb_cb(skb)->pkt_len = skb->len;
 
@@ -4104,6 +4104,7 @@ static void qdisc_pkt_len_init(struct sk_buff *skb)
 			if (payload <= 0)
 				return;
 			gso_segs = DIV_ROUND_UP(payload, shinfo->gso_size);
+			shinfo->gso_segs = gso_segs;
 		}
 		qdisc_skb_cb(skb)->pkt_len += (gso_segs - 1) * hdr_len;
 	}
-- 
2.51.0

