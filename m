Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E271A617E;
	Tue, 30 Jul 2024 16:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357171; cv=none; b=m0n73eDvSXGQKl/EssNC6UDeHMPhZH9Z+jrcnMWRtaqEUA12ONZFoxcXybxNfrD3wHTVGuPxg+GnYYDuaVqD5zSwCv42ZuB9bqg9uAGnnlNIhxjRoO4iu8dqkFhL2qfA426GEtSeK+lsLJK6ComH5QbB+TyVa8Xtpfpep/Npj/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357171; c=relaxed/simple;
	bh=DH8KMcV9ouPpWl1nlWAlUc6/3ROecUiO6WzvHhh3Kzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oEX+g7qeakShhaa82YiU//4PNqppbgo9Lwir72EbWBfOB1WA6jogvq/UrscMbHX45YKyGyCGmQdBvawzGctKKfWDK/6XOvNuGDtqL7BO13IXgWrKyZbQ4lkLVV8RSJmJKDf9WvSdJPKVVZrrZ+PPD9TvFMA9q573EzBM346HJk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tp4ytx/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tp4ytx/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C647AC32782;
	Tue, 30 Jul 2024 16:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357171;
	bh=DH8KMcV9ouPpWl1nlWAlUc6/3ROecUiO6WzvHhh3Kzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tp4ytx/D4M7xCQMM3n+HPi7pFv9+PWBl2HLDcy/SQeFpggdJIpj3Po6U50pe0D/Sm
	 yzAjS6pynNf2j3MwVOyiycn76BCFuNHClgwyyirOYgaSlyb9b4vge/xpXV1eSePgpQ
	 5l55jybWit+lClNE9vIc2U871zguMbPMlNQ1l+Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 222/809] perf/x86/intel/pt: Fix pt_topa_entry_for_page() address calculation
Date: Tue, 30 Jul 2024 17:41:38 +0200
Message-ID: <20240730151733.375876758@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 3520b251dcae2b4a27b95cd6f745c54fd658bda5 ]

Currently, perf allocates an array of page pointers which is limited in
size by MAX_PAGE_ORDER. That in turn limits the maximum Intel PT buffer
size to 2GiB. Should that limitation be lifted, the Intel PT driver can
support larger sizes, except for one calculation in
pt_topa_entry_for_page(), which is limited to 32-bits.

Fix pt_topa_entry_for_page() address calculation by adding a cast.

Fixes: 39152ee51b77 ("perf/x86/intel/pt: Get rid of reverse lookup table for ToPA")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240624201101.60186-4-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 14db6d9d318b3..c3259164a8e46 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -990,7 +990,7 @@ pt_topa_entry_for_page(struct pt_buffer *buf, unsigned int pg)
 	 * order allocations, there shouldn't be many of these.
 	 */
 	list_for_each_entry(topa, &buf->tables, list) {
-		if (topa->offset + topa->size > pg << PAGE_SHIFT)
+		if (topa->offset + topa->size > (unsigned long)pg << PAGE_SHIFT)
 			goto found;
 	}
 
-- 
2.43.0



