Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740B031CA62;
	Mon, 18 Aug 2025 12:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521822; cv=none; b=a/Ww6jJ9Zd4KKuedzbsx/a79S+SAIAMJMSy4tr7+9BPPUxO7O84DJG8L/a5pTQIS0eRyHNc1LRxnAAOzvJB9ZoxcZ6cP8BS3TUYvDS0433hHdsq0fCV0TM/koMo9pq2HKUs96bNW3UP5e7TKl/VKNO9J5d5hQe5jfDkUjaI1lgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521822; c=relaxed/simple;
	bh=QTEZBzJpEg33TRqxSDLnjRxYVVfLJyEd2nLpGGWRIKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNkaIpqBej4mA5vxkM0qpiu6WtKOhgfYa7ZDil5ipTS45hhLFZDwpon60npI2WA0in1J1gO1uP9KTkQ7O8acpcioBuvbtxwk1sVbaRiG8BdyCDSOEIjdwkt+MVC2mTR1emuaAiuOnL6KVafcoE5rwKGj2gX6ePrst2hmqsJdUts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GA/zCEh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GA/zCEh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCCCC4CEEB;
	Mon, 18 Aug 2025 12:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521822;
	bh=QTEZBzJpEg33TRqxSDLnjRxYVVfLJyEd2nLpGGWRIKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GA/zCEh51S2sCiWBugcfvpfSGV50lvVG1sP1H8OE1vEtkqbDWYoIIDhJ3fevosUow
	 5RZgKYsDh5DUHxerlqIl6cbOJEE8dFPbz72K5SD5DKGVqYaSID3JtnCK+j+l0c78+c
	 Gb/7A8eqBKIQb1SURfFCWYBB17oqHkS55tp8b4xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/444] ACPI: APEI: GHES: add TAINT_MACHINE_CHECK on GHES panic path
Date: Mon, 18 Aug 2025 14:42:38 +0200
Message-ID: <20250818124453.862351640@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 4734c8b46b901cff2feda8b82abc710b65dc31c1 ]

When a GHES (Generic Hardware Error Source) triggers a panic, add the
TAINT_MACHINE_CHECK taint flag to the kernel. This explicitly marks the
kernel as tainted due to a machine check event, improving diagnostics
and post-mortem analysis. The taint is set with LOCKDEP_STILL_OK to
indicate lockdep remains valid.

At large scale deployment, this helps to quickly determine panics that
are coming due to hardware failures.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20250702-add_tain-v1-1-9187b10914b9@debian.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 94e3d3fe11ae..91f9267c07ea 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -996,6 +996,8 @@ static void __ghes_panic(struct ghes *ghes,
 
 	__ghes_print_estatus(KERN_EMERG, ghes->generic, estatus);
 
+	add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
+
 	ghes_clear_estatus(ghes, estatus, buf_paddr, fixmap_idx);
 
 	if (!panic_timeout)
-- 
2.39.5



