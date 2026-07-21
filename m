Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8003401494;
	Tue, 21 Jul 2026 17:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654328; cv=none; b=X1QDzNZzXnNGI0LN3Rrg4eAjkWPHIsjh4Sdrbfltg3FPo5chq3WdYIK5O7UekL7AOo8lLYSckEAn1fyIslV3PPYvHwUolNuC2oxN5aZHG4llU1rebcAthxXTdnIMbgzLRRKzze+MKO3NzXwk+95FRaruNCNQeGCGDPu2vCt5D0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654328; c=relaxed/simple;
	bh=4QNn4yJ1vuuqKORWuGkyToJZ13akXRcgk2Paz+sOSR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKcowsdOdk7yUPzMbUvO3r7HCsWPgqTufB52eRiz5JbRg9sT7VOKYvf7/71cYQSNf0UeMfjgW+t1jRAkn61yC9Pas/YZ1M1u09y2Wmrvh52iugDXO+jdj40I9vhZB/E9spUIaDTpBD1ddMKqPJ1x5wKTl9j/TmIhBFfAWjdUboM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A77hqaKO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A77hqaKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFBC1F000E9;
	Tue, 21 Jul 2026 17:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654325;
	bh=Iqvibahc/KdLkdvjnmPWgrA3LM2ZJch02SJT2gIney0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A77hqaKOQZKctByR4ZijDmRSi4IUGljlB0YUZ6o0H/X1kuJM4LHi/s4SnU9nw5P4Y
	 HkXBxFo7zXrF5UM7CHmKiHJ2bYe4aYS2/U37l5YVOnbVNUuENca/tJDGzE2g8rG5fr
	 nIBBP8haX/NEcuh52FEl19ppc9Abo0Fu2dKlDlA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>
Subject: [PATCH 7.1 1618/2077] gpu: nova-core: simplify and_then with condition to filter
Date: Tue, 21 Jul 2026 17:21:31 +0200
Message-ID: <20260721152630.923478437@linuxfoundation.org>
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

From: Eliot Courtney <ecourtney@nvidia.com>

commit 16df3873c80388a71c4695909a51be0c809b889c upstream.

This code is more simply expressed using Option::filter instead of the
and_then with conditional.

This fixes the following warning with latest nightly Rust clippy build:

warning: manual implementation of `Option::filter`
   --> drivers/gpu/nova-core/firmware.rs:391:14
    |
391 |               .and_then(|hdr| {
    |  ______________^
392 | |                 if hdr.bin_magic == BIN_MAGIC {
393 | |                     Some(hdr)
394 | |                 } else {
...   |
397 | |             })
    | |______________^ help: try: `filter(|hdr| hdr.bin_magic == BIN_MAGIC)`
    |
    = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#manual_filter
    = note: `-D clippy::manual-filter` implied by `-D warnings`
    = help: to override `-D warnings` add `#[allow(clippy::manual_filter)]`

Cc: stable@vger.kernel.org
Fixes: d6cb7319e64e ("gpu: nova-core: firmware: add support for common firmware header")
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260423-fix-filter-v1-1-b3b197c65daf@nvidia.com
[aliceryhl: add Fixes: tag and quote the warning it fixes]
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/nova-core/firmware.rs |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/gpu/nova-core/firmware.rs
+++ b/drivers/gpu/nova-core/firmware.rs
@@ -388,13 +388,7 @@ impl<'a> BinFirmware<'a> {
             // Extract header.
             .and_then(BinHdr::from_bytes_copy)
             // Validate header.
-            .and_then(|hdr| {
-                if hdr.bin_magic == BIN_MAGIC {
-                    Some(hdr)
-                } else {
-                    None
-                }
-            })
+            .filter(|hdr| hdr.bin_magic == BIN_MAGIC)
             .map(|hdr| Self { hdr, fw })
             .ok_or(EINVAL)
     }


