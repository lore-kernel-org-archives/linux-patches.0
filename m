Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5092338DEC;
	Tue, 26 Aug 2025 12:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212814; cv=none; b=gq18qESzbD8SJcHKxOHtaBc7br5XvSRdYuxiaTY3sI8WOK6ZxI/pwPIiBlHVWmTi/oZ/i46V96KQNGx9sf5MhjOc/B6MPtg5eoZ5kh/0Hmr75ppn5UPukWfbkfEmf7a+/XFOfVpakrcVhJtttHW/2deqEXP8B4C3a0OHrdXsQTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212814; c=relaxed/simple;
	bh=09t4o7puzMB1m7xAmZ8aSMn1lMHXEBLR/y8J1zmM4/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLucjn2cgEK2OyMVQXLAOcf0iJfbNpfUM5wDGPd+8D631bS5zYhRC9UC19hkjRj79KuWLQOYete6D42nyGadSO3/Fd0ay0KF62tmvWo0A56bz1QCydjESu8aoF01hbljsYzeLZApfnNObAuolFPHqWuXWKLXGgafafxYUpsvrhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JA/8d2X0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JA/8d2X0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD16C4CEF1;
	Tue, 26 Aug 2025 12:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212814;
	bh=09t4o7puzMB1m7xAmZ8aSMn1lMHXEBLR/y8J1zmM4/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JA/8d2X021wNbu+HjtWZFQkL46/TSSaCk/Hk1d9g5CP8R8b2TQ5T2o6dIqbXGaOfb
	 2CqA8bXaZjUaLjS8xq3dn9nEu+oM70quxUZl9PllQ0siUGp2UrAeCdKLs6xQ2cuEoC
	 u8B25PhqdAqwNwlbSMiDwhBsvjyotwP3ed4Qzq7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/587] ACPI: processor: fix acpi_object initialization
Date: Tue, 26 Aug 2025 13:04:21 +0200
Message-ID: <20250826110955.789906268@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Ott <sebott@redhat.com>

[ Upstream commit 13edf7539211d8f7d0068ce3ed143005f1da3547 ]

Initialization of the local acpi_object in acpi_processor_get_info()
only sets the first 4 bytes to zero and is thus incomplete. This is
indicated by messages like:
	acpi ACPI0007:be: Invalid PBLK length [166288104]

Fix this by initializing all 16 bytes of the processor member of that
union.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Link: https://patch.msgid.link/20250703124215.12522-1-sebott@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 7053f1b9fc1d..c0f9cf9768ea 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -250,7 +250,7 @@ static inline int acpi_processor_hotadd_init(struct acpi_processor *pr)
 
 static int acpi_processor_get_info(struct acpi_device *device)
 {
-	union acpi_object object = { 0 };
+	union acpi_object object = { .processor = { 0 } };
 	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
 	struct acpi_processor *pr = acpi_driver_data(device);
 	int device_declaration = 0;
-- 
2.39.5



