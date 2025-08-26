Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8496D352077;
	Tue, 26 Aug 2025 14:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217774; cv=none; b=UaVTGr5wg5ryyeU/eG1dMqzsJa4zKWp7AQVPgllYSd2tRmaw2H+WJHatfpeCRO2bBg9cBdN7+FQfvVm3L32lUkhcWccfUTcbNj21XsumKOHpXJMxb7LAkqXWnCuycYrISn3vXcvqKKXd4rWvH0y1JKvwULZXC9goixqTV1QAu08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217774; c=relaxed/simple;
	bh=Zug/W8D7FlhGlMv/B1NxHOlvlbZGsZPenZ0DXnXgR6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nns2sCX+x+nJQJ9qDMm8/GSvfBOuCK3JiqjHXzU5J1btta0dMHIn8E9uavItURYqGsdg+oaOZZ0fmLGJHDvCHvZ0v3zA1gE1otNeiE3vVjrztzqiF2LNnNfy1U3SF0JQrRD6dzDlX5HGB90W1QoWZ6rnM71Fw5gImFJgN/Q7Vok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzR4qvmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzR4qvmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D50CC4CEF1;
	Tue, 26 Aug 2025 14:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217774;
	bh=Zug/W8D7FlhGlMv/B1NxHOlvlbZGsZPenZ0DXnXgR6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzR4qvmf4ghoJVRu40KXDKkVoUVtRgeGH+j414uf68FD1fX2ahddOGCoark9+Zn50
	 muGCHUwxmMRpSYgXqnkJ/kOKb7ohJyvFr7Khah6TgwOYxSfbGPkw6LL73aFfl3txQW
	 dviULzIY9qvgUq6HJDsQCN+iFoq1imQINgkOJHyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 239/523] ACPI: processor: fix acpi_object initialization
Date: Tue, 26 Aug 2025 13:07:29 +0200
Message-ID: <20250826110930.339619044@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 707b2c37e5ee..74e949d340a1 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -228,7 +228,7 @@ static inline int acpi_processor_hotadd_init(struct acpi_processor *pr)
 
 static int acpi_processor_get_info(struct acpi_device *device)
 {
-	union acpi_object object = { 0 };
+	union acpi_object object = { .processor = { 0 } };
 	struct acpi_buffer buffer = { sizeof(union acpi_object), &object };
 	struct acpi_processor *pr = acpi_driver_data(device);
 	int device_declaration = 0;
-- 
2.39.5



