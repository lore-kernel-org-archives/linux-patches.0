Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A3229B79B;
	Fri, 20 Feb 2026 12:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771591088; cv=none; b=Fqj78PKeSYBFas0SI+QHL8ggPj/AZTpk91KeSEMWxRrouRXMhpgL3tnfj37mjFtDkv/bINq6bXaXsSnJfAngRrSqUP9UyvGW7Km51wzZa5M2TGdJhSpmhUQOhxtZKAz/XvG1/MJpPirwZ/qksAq9xlHAfIROKoeZ4oF0PYxfvb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771591088; c=relaxed/simple;
	bh=PcXHPkPK8Tu8BLTVlD50Lp9knCyg3f3SAsJ8fwwB/UA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jXZ83N+KTDP4xd69/RQPwrLQtMFA0MTZjmWupp/a9A6VBfmAfJaGPoe7gU+fOwNUi/GeCPDDS4bol8xNrs4neRl3RupQ6H+fnjNZFhxeYiFtYvzYZP1PJEXHyPYJ9V8OfiHYUkoBp/qUh+zIZz9f+e1ulyqfeuOFtWyZaMb7Vvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rzc807DJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rzc807DJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CE8C116C6;
	Fri, 20 Feb 2026 12:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771591087;
	bh=PcXHPkPK8Tu8BLTVlD50Lp9knCyg3f3SAsJ8fwwB/UA=;
	h=From:To:Cc:Subject:Date:From;
	b=rzc807DJlNxrul32rjTNYOxCgSSWlvY3WaB9zvH1JBlH3lzPGiKv7G0Xl1ZLQpBJl
	 Qc5PUtN50OUL+gDw3IpxfRiaUKuuZerC5FsrppogPZscpOnaIWXRBKwycXDhMi4z94
	 KdBktkJ1L3UjBLwNBsf6CXVI6wLkFKfAKdByDUPsFRjh5w7NMYB9T/cIY0bAUPuA9e
	 rZIZi5ZgWoKJyFC1/Sj0BCKqZH1EOiEjssPixLKZfTdZZNbVeGM2HQICGVkClW/JE+
	 4JyOtbO0mFuh5YmhBdVNU81NwCrmSWkRb9wSNOMXFBxRgPZ99/w/GBgCYt+Wfkh3Hx
	 erpsz1HjlgVxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	amarkuze@redhat.com,
	slava@dubeyko.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] libceph: define and enforce CEPH_MAX_KEY_LEN
Date: Fri, 20 Feb 2026 07:37:50 -0500
Message-ID: <20260220123805.3371698-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Dryomov <idryomov@gmail.com>

[ Upstream commit ac431d597a9bdfc2ba6b314813f29a6ef2b4a3bf ]

When decoding the key, verify that the key material would fit into
a fixed-size buffer in process_auth_done() and generally has a sane
length.

The new CEPH_MAX_KEY_LEN check replaces the existing check for a key
with no key material which is a) not universal since CEPH_CRYPTO_NONE
has to be excluded and b) doesn't provide much value since a smaller
than needed key is just as invalid as no key -- this has to be handled
elsewhere anyway.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the vulnerability. Now let me provide my complete
analysis.

## Analysis

### What the commit does

This commit makes three changes to the libceph subsystem:

1. **Renames `CEPH_KEY_LEN` to `CEPH_MAX_KEY_LEN`** (value remains 16)
   in `net/ceph/crypto.h` to clarify the constant's purpose as a maximum
   bound.

2. **Adds a bounds check** in `ceph_crypto_key_decode()`
   (`net/ceph/crypto.c:83-86`) that validates `key->len <=
   CEPH_MAX_KEY_LEN` before the key material is used. The old
   `!key->len` check in `set_secret()` is removed as it's superseded by
   this.

3. **Updates the buffer reference** in `process_auth_done()`
   (`net/ceph/messenger_v2.c:2363`) to use the renamed constant.

### The vulnerability: Stack buffer overflow from network data

This is a **security fix** preventing a potential stack buffer overflow:

1. `process_auth_done()` allocates a fixed-size stack buffer: `u8
   session_key_buf[CEPH_KEY_LEN + 16]` (32 bytes, of which 16 are usable
   after alignment).

2. This buffer is passed to `handle_auth_done()` →
   `ceph_auth_handle_reply_done()` → `handle_auth_session_key()` in
   `auth_x.c:627-629`, which does:
  ```c
  memcpy(session_key, th->session_key.key, th->session_key.len);
  ```

3. `th->session_key` is populated by `ceph_crypto_key_decode()` in
   `process_one_ticket()` (`auth_x.c:207`), where `key->len` is decoded
   directly from the network as a 16-bit integer with **no upper bounds
   validation**.

4. A malicious or compromised Ceph server (or MITM attacker) could send
   a key length > 16, causing a stack buffer overflow when the key
   material is `memcpy`'d into the 16-byte `session_key_buf`.

### Stable kernel criteria assessment

- **Fixes a real bug**: Yes - a security vulnerability (stack buffer
  overflow from network input)
- **Obviously correct**: Yes - adding a bounds check on network-decoded
  length against a buffer size constant is straightforward
- **Small and contained**: Yes - only ~10 lines of meaningful change
  across 3 files
- **No new features**: Correct - this only adds input validation
- **Tested**: The author is Ilya Dryomov, the Ceph subsystem maintainer
  himself

### Risk assessment

- **Very low risk**: The only behavioral change is rejecting keys with
  length > 16 bytes. AES-128 keys are 16 bytes, so valid Ceph keys will
  never be larger. There's no possibility of breaking existing working
  setups.
- **High benefit**: Prevents a remotely triggerable stack buffer
  overflow in the kernel.

### Related commits

Commit `818156caffbf5` ("libceph: prevent potential out-of-bounds reads
in handle_auth_done()") was a related security fix with explicit `Cc:
stable@vger.kernel.org`, showing the Ceph maintainer considers these
auth handling bounds checks to be stable-worthy.

### Verification

- **Verified call chain**: `process_auth_done()` (messenger_v2.c:2361) →
  `handle_auth_done` callback → `handle_auth_session_key()`
  (auth_x.c:627-629) copies `th->session_key.key` with length
  `th->session_key.len` into the fixed-size `session_key` buffer via
  `memcpy`.
- **Verified network origin of key->len**: `ceph_crypto_key_decode()`
  (crypto.c:82) reads `key->len = ceph_decode_16(p)` directly from
  network-supplied data, with only `ceph_decode_need()` checking buffer
  availability, not the value itself.
- **Verified buffer size**: `session_key_buf` at messenger_v2.c:2363 is
  `CEPH_KEY_LEN + 16 = 32` bytes, with usable session key portion being
  only 16 bytes after `PTR_ALIGN`.
- **Verified related commit**: `git show 818156caffbf5` confirmed it's
  another auth bounds-check fix with explicit `Cc:
  stable@vger.kernel.org` and review from the same maintainer (Ilya
  Dryomov).
- **Verified the process_one_ticket path**: auth_x.c:207 shows
  `ceph_crypto_key_decode(&new_session_key, &dp, dend)` decoding the key
  from encrypted ticket data received from the network.
- **Verified the old check was insufficient**: The removed `if
  (!key->len) return -EINVAL` in `set_secret()` only rejected zero-
  length keys, not oversized ones.

### Conclusion

This is a clear security fix that prevents a remotely triggerable stack
buffer overflow in the Ceph authentication path. The fix is minimal,
obviously correct, and has no risk of regression. The Ceph subsystem
maintainer authored it himself, and a closely related commit was
explicitly marked for stable. This meets all stable kernel criteria.

**YES**

 net/ceph/crypto.c       | 8 +++++---
 net/ceph/crypto.h       | 2 +-
 net/ceph/messenger_v2.c | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 01b2ce1e8fc06..5601732cf4faa 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -37,9 +37,6 @@ static int set_secret(struct ceph_crypto_key *key, void *buf)
 		return -ENOTSUPP;
 	}
 
-	if (!key->len)
-		return -EINVAL;
-
 	key->key = kmemdup(buf, key->len, GFP_NOIO);
 	if (!key->key) {
 		ret = -ENOMEM;
@@ -83,6 +80,11 @@ int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end)
 	ceph_decode_copy(p, &key->created, sizeof(key->created));
 	key->len = ceph_decode_16(p);
 	ceph_decode_need(p, end, key->len, bad);
+	if (key->len > CEPH_MAX_KEY_LEN) {
+		pr_err("secret too big %d\n", key->len);
+		return -EINVAL;
+	}
+
 	ret = set_secret(key, *p);
 	memzero_explicit(*p, key->len);
 	*p += key->len;
diff --git a/net/ceph/crypto.h b/net/ceph/crypto.h
index 23de29fc613cf..a20bad6d1e964 100644
--- a/net/ceph/crypto.h
+++ b/net/ceph/crypto.h
@@ -5,7 +5,7 @@
 #include <linux/ceph/types.h>
 #include <linux/ceph/buffer.h>
 
-#define CEPH_KEY_LEN			16
+#define CEPH_MAX_KEY_LEN		16
 #define CEPH_MAX_CON_SECRET_LEN		64
 
 /*
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index c9d50c0dcd33a..31e042dc1b3f2 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2360,7 +2360,7 @@ static int process_auth_reply_more(struct ceph_connection *con,
  */
 static int process_auth_done(struct ceph_connection *con, void *p, void *end)
 {
-	u8 session_key_buf[CEPH_KEY_LEN + 16];
+	u8 session_key_buf[CEPH_MAX_KEY_LEN + 16];
 	u8 con_secret_buf[CEPH_MAX_CON_SECRET_LEN + 16];
 	u8 *session_key = PTR_ALIGN(&session_key_buf[0], 16);
 	u8 *con_secret = PTR_ALIGN(&con_secret_buf[0], 16);
-- 
2.51.0

