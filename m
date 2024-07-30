Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5208F1917D9;
	Tue, 30 Jul 2024 17:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359365; cv=none; b=mhy9iFEqH7xfVNnDoPO4tQ8vrhGWRk7s1yAyUvSIiScVvgSUSh02mmMs8cyo06/zaymOB97n4Ppc9IEjCi/bUpXKRGwWBt6/G0F3yONcaujvw7wg6z1FW0dVjqHEusvpmBrcnAV+J0Vk7D488LKwbbaT7oHFiFSA714ACmkxbGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359365; c=relaxed/simple;
	bh=bB9ciEkVdTOl5/4x/Y32qDeRhqU4gqgBWTcWlm/Iqw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aj2Y7CkqO5lkbWpLUtJ4GU1vhALXmoLDGfWvQO11JSBZfLie85Lvni3zXNzo7QJkjnu6650WZ2OUEPwPAyHTFwdORJ/auvI1PUZrR2AT68jN1P01vCWaYRThy9BKyL0hoKtKX6K+ULLIS3VLWMm3S281+KifoWfjrmSb7AOjv8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGAoi0Rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGAoi0Rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B960FC32782;
	Tue, 30 Jul 2024 17:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359365;
	bh=bB9ciEkVdTOl5/4x/Y32qDeRhqU4gqgBWTcWlm/Iqw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGAoi0RmGoJu47tpU1HGa5qHUTtP9kaCWOkeHJCrdaDZQu9OFs+zHtXFwsCj0vcX8
	 ya7sHTTay1lrW46LeHCBC3dHpljshopriUB+6Sg4e3fGSbRAlOG1mNs3a0DxFXpUMd
	 xtq3xLXKvRjAuwfO+u6d7eaLqtTlhMCMUOBEk5Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Cavenati <cavenati.marco@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 472/568] perf/x86/intel/pt: Fix topa_entry base length
Date: Tue, 30 Jul 2024 17:49:39 +0200
Message-ID: <20240730151658.473625967@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Cavenati <cavenati.marco@gmail.com>

commit 5638bd722a44bbe97c1a7b3fae5b9efddb3e70ff upstream.

topa_entry->base needs to store a pfn.  It obviously needs to be
large enough to store the largest possible x86 pfn which is
MAXPHYADDR-PAGE_SIZE (52-12).  So it is 4 bits too small.

Increase the size of topa_entry->base from 36 bits to 40 bits.

Note, systems where physical addresses can be 256TiB or more are affected.

[ Adrian: Amend commit message as suggested by Dave Hansen ]

Fixes: 52ca9ced3f70 ("perf/x86/intel/pt: Add Intel PT PMU driver")
Signed-off-by: Marco Cavenati <cavenati.marco@gmail.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240624201101.60186-2-adrian.hunter@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/pt.h
+++ b/arch/x86/events/intel/pt.h
@@ -33,8 +33,8 @@ struct topa_entry {
 	u64	rsvd2	: 1;
 	u64	size	: 4;
 	u64	rsvd3	: 2;
-	u64	base	: 36;
-	u64	rsvd4	: 16;
+	u64	base	: 40;
+	u64	rsvd4	: 12;
 };
 
 /* TSC to Core Crystal Clock Ratio */


