Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8D4222D74;
	Thu, 12 Dec 2024 17:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025899; cv=none; b=WHme9ZiCbmNNIcRxO0lBE7XRSQytFAJwoYzsuleNNPg03o5S+HgQ9EV1nmY/KxEZwnDh0J0uEHr6JIwUDvZr5Nn/RS3ZiBKxO3etvEawTvPOupWlYVE2qsvKgtxVVHZPgq/B6bZW7E7wwIWK6sqaQfx/j6qHtq49wYi/le9WoO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025899; c=relaxed/simple;
	bh=lSzGU+yiFFCfcdnP9uNdRxPAgjjSh2szdLIS3O2FML0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WG5S24yL88VcPYs3/4Mv1jrLp6K/WHaOD31f9Z8PaxwYjpVIJwpDahXAmNf2sRJ5bjXMqfUx3As1dUjffq+jYu9JLgXu9nspk2WrEOoztspC8BjiiNsFNaTSKCecLTpwwqD3MdX7+MbspsgzHA3g3qJLYxvf1yyXV0ddyYoPQAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0P+RT8xP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0P+RT8xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0C5C4CECE;
	Thu, 12 Dec 2024 17:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025899;
	bh=lSzGU+yiFFCfcdnP9uNdRxPAgjjSh2szdLIS3O2FML0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0P+RT8xPEB8ncM6kHvj9bfX7URlBTEWf4sXrfbGg2TqJxs7NlszF6tELbMhb4uA1X
	 ieaL/dHrvmWlzfzWhrU1GKkp/UrGnrG97gTOiCnJzCcuVGecLsXFyq5nT7ZceIdUt4
	 ksrCPPvLb1/rJrT0HquhJkmaWSN/9Q9nm1ue6nmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 310/321] perf/x86/intel/pt: Fix buffer full but size is 0 case
Date: Thu, 12 Dec 2024 16:03:48 +0100
Message-ID: <20241212144242.229446866@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 5b590160d2cf776b304eb054afafea2bd55e3620 upstream.

If the trace data buffer becomes full, a truncated flag [T] is reported
in PERF_RECORD_AUX.  In some cases, the size reported is 0, even though
data must have been added to make the buffer full.

That happens when the buffer fills up from empty to full before the
Intel PT driver has updated the buffer position.  Then the driver
calculates the new buffer position before calculating the data size.
If the old and new positions are the same, the data size is reported
as 0, even though it is really the whole buffer size.

Fix by detecting when the buffer position is wrapped, and adjust the
data size calculation accordingly.

Example

  Use a very small buffer size (8K) and observe the size of truncated [T]
  data. Before the fix, it is possible to see records of 0 size.

  Before:

    $ perf record -m,8K -e intel_pt// uname
    Linux
    [ perf record: Woken up 2 times to write data ]
    [ perf record: Captured and wrote 0.105 MB perf.data ]
    $ perf script -D --no-itrace | grep AUX | grep -F '[T]'
    Warning:
    AUX data lost 2 times out of 3!

    5 19462712368111 0x19710 [0x40]: PERF_RECORD_AUX offset: 0 size: 0 flags: 0x1 [T]
    5 19462712700046 0x19ba8 [0x40]: PERF_RECORD_AUX offset: 0x170 size: 0xe90 flags: 0x1 [T]

 After:

    $ perf record -m,8K -e intel_pt// uname
    Linux
    [ perf record: Woken up 3 times to write data ]
    [ perf record: Captured and wrote 0.040 MB perf.data ]
    $ perf script -D --no-itrace | grep AUX | grep -F '[T]'
    Warning:
    AUX data lost 2 times out of 3!

    1 113720802995 0x4948 [0x40]: PERF_RECORD_AUX offset: 0 size: 0x2000 flags: 0x1 [T]
    1 113720979812 0x6b10 [0x40]: PERF_RECORD_AUX offset: 0x2000 size: 0x2000 flags: 0x1 [T]

Fixes: 52ca9ced3f70 ("perf/x86/intel/pt: Add Intel PT PMU driver")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20241022155920.17511-2-adrian.hunter@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.c |   11 ++++++++---
 arch/x86/events/intel/pt.h |    2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -782,11 +782,13 @@ static void pt_buffer_advance(struct pt_
 	buf->cur_idx++;
 
 	if (buf->cur_idx == buf->cur->last) {
-		if (buf->cur == buf->last)
+		if (buf->cur == buf->last) {
 			buf->cur = buf->first;
-		else
+			buf->wrapped = true;
+		} else {
 			buf->cur = list_entry(buf->cur->list.next, struct topa,
 					      list);
+		}
 		buf->cur_idx = 0;
 	}
 }
@@ -800,8 +802,11 @@ static void pt_buffer_advance(struct pt_
 static void pt_update_head(struct pt *pt)
 {
 	struct pt_buffer *buf = perf_get_aux(&pt->handle);
+	bool wrapped = buf->wrapped;
 	u64 topa_idx, base, old;
 
+	buf->wrapped = false;
+
 	/* offset of the first region in this table from the beginning of buf */
 	base = buf->cur->offset + buf->output_off;
 
@@ -814,7 +819,7 @@ static void pt_update_head(struct pt *pt
 	} else {
 		old = (local64_xchg(&buf->head, base) &
 		       ((buf->nr_pages << PAGE_SHIFT) - 1));
-		if (base < old)
+		if (base < old || (base == old && wrapped))
 			base += buf->nr_pages << PAGE_SHIFT;
 
 		local_add(base - old, &buf->data_size);
--- a/arch/x86/events/intel/pt.h
+++ b/arch/x86/events/intel/pt.h
@@ -64,6 +64,7 @@ struct pt_pmu {
  * @lost:	if data was lost/truncated
  * @head:	logical write offset inside the buffer
  * @snapshot:	if this is for a snapshot/overwrite counter
+ * @wrapped:	buffer advance wrapped back to the first topa table
  * @stop_pos:	STOP topa entry index
  * @intr_pos:	INT topa entry index
  * @stop_te:	STOP topa entry pointer
@@ -80,6 +81,7 @@ struct pt_buffer {
 	local_t			data_size;
 	local64_t		head;
 	bool			snapshot;
+	bool			wrapped;
 	long			stop_pos, intr_pos;
 	struct topa_entry	*stop_te, *intr_te;
 	void			**data_pages;


