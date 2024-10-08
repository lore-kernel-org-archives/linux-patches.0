Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1D51DFE36;
	Tue,  8 Oct 2024 13:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394067; cv=none; b=AjcY5PTxK6BADlZ46Q4VeR8VY0miEfQrj5Q7sYAr5cJG986YiBsZoso20sEV9WQmhriRfcqMjDwiX7ZIbMC6i3qKDSMHoRSSCtkb0XPPHdvGHrQM8eU8f/O9JS2Jw/+LIQgsZw0Bhd6zGMQdieMkDc3ozUdHEHx+vjnlzt/b1Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394067; c=relaxed/simple;
	bh=s8uBH/qD1xp5JCObtC8waIezkpDg9wsBMdAd6UI6Ewk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0WF7C5jBkhU9y9S28mhJ1AFlTvjpbdfcxiYze40UCXlhiA7bGUEZg/oSK7OIoJosWL1CSwTqEw7HAasf1OPQr/nly79kkw0mGV0CAVuNN6R8SaucRzMrWVq9XJnht5rvDWkAezl+NFP7xXBngaqlQF8lMM+iBlozRA6Wii0zUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyIRuPG1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyIRuPG1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A64DC4CEC7;
	Tue,  8 Oct 2024 13:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394067;
	bh=s8uBH/qD1xp5JCObtC8waIezkpDg9wsBMdAd6UI6Ewk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyIRuPG1CkgJYUUCT2KTyn480/cj1lfr3osAGWWjsL4yXENNMUzd8AznUBhmuIzBv
	 sTnUkd552Gj/3RmIAeJY+OFNIXBjqrgQnUfpxT4qNT0vDr1/HMiVwqlfxjnG+VftB3
	 R5Kqdkf51UCEWQb1BL832RkSB1jFTRaqs8Jt6wOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 338/386] uprobes: fix kernel info leak via "[uprobes]" vma
Date: Tue,  8 Oct 2024 14:09:43 +0200
Message-ID: <20241008115642.684244284@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Oleg Nesterov <oleg@redhat.com>

commit 34820304cc2cd1804ee1f8f3504ec77813d29c8e upstream.

xol_add_vma() maps the uninitialized page allocated by __create_xol_area()
into userspace. On some architectures (x86) this memory is readable even
without VM_READ, VM_EXEC results in the same pgprot_t as VM_EXEC|VM_READ,
although this doesn't really matter, debugger can read this memory anyway.

Link: https://lore.kernel.org/all/20240929162047.GA12611@redhat.com/

Reported-by: Will Deacon <will@kernel.org>
Fixes: d4b3b6384f98 ("uprobes/core: Allocate XOL slots for uprobes use")
Cc: stable@vger.kernel.org
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 6876b7f152b10..6dac0b5798213 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1491,7 +1491,7 @@ static struct xol_area *__create_xol_area(unsigned long vaddr)
 
 	area->xol_mapping.name = "[uprobes]";
 	area->xol_mapping.pages = area->pages;
-	area->pages[0] = alloc_page(GFP_HIGHUSER);
+	area->pages[0] = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
 	if (!area->pages[0])
 		goto free_bitmap;
 	area->pages[1] = NULL;
-- 
2.43.0



