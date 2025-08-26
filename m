Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09182187554;
	Tue, 26 Aug 2025 13:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214308; cv=none; b=XhRC5WcG2nySuGhJBnmx0v4T0zIrIxGiiAJG8V3bp5t2yAEYtCbZJCl8QI8s8ykRAwL0CSQOw/IBUg+r0TxMWWEE7zGBN1hEcwa4EiJmX5Oyy+cnKFG4nhrlx5xgNinE8nz/DKYGC6jNLR0yX7upRtLuCe2DJpU3il4f/enLDHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214308; c=relaxed/simple;
	bh=ppWK1dSEJzM9+MLPTF2QvCL4qOGZIhSgLhEUVnG+6EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BF4E46DsyeTAYy5iBROJwfF4MX79sTdpnQ1goPup5+vOq4QSRfOfpEr35O3XtlTbGuEuI0/+6MlqcHlYYXGLAH01A7PpMjqLzw39dcxjix0GDTb7xktYwL6WkUNtAG7ogCgrS5oD1Vzc7ECakRhztH5bh8PQDSnWFRJHeGJ4z9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auDbYgda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auDbYgda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E2FC4CEF1;
	Tue, 26 Aug 2025 13:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214307;
	bh=ppWK1dSEJzM9+MLPTF2QvCL4qOGZIhSgLhEUVnG+6EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auDbYgdaRLWdy1dZohvQsbH3tahPlPLscq5azuovaBpucggZlGvp67UtPmvQ2rSs2
	 PCiuq0EO8d29NWT45NNixSz1Jm64jmoKX1UC8QDIzXUjWGW82rpEBWxOpKYVYNBb60
	 cyxNM7CdxhiN1RNeE9nj7QlOgS+g8Tg2WPzO5vkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/482] ACPI: processor: fix acpi_object initialization
Date: Tue, 26 Aug 2025 13:05:43 +0200
Message-ID: <20250826110933.050904050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8bd5c4fa91f2..cfa75b14caa2 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -216,7 +216,7 @@ static inline int acpi_processor_hotadd_init(struct acpi_processor *pr)
 
 static int acpi_processor_get_info(struct acpi_device *device)
 {
-	union acpi_object object = { 0 };
+	union acpi_object object = { .processor = { 0 } };
 	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
 	struct acpi_processor *pr = acpi_driver_data(device);
 	int device_declaration = 0;
-- 
2.39.5



