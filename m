Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117141C9DF9;
	Mon, 14 Oct 2024 15:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918983; cv=none; b=pfhsUER785QyTe1kYX2HQzL/WPVgnFJNZN6gA5sIXS9hRIsOasiG+FPz6oasar+4tlbLjtuRpT2AGvw/KxDs355W6dhd9SX3CRRDHkHZ7PMTliDHRvY7qbQXuut8ITsikuBjhfY7nx7O6nBZE1CYU2eS/RiD16C4nAL91kX8Gmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918983; c=relaxed/simple;
	bh=xpzQWfvHAiZRzq5Xz1ZScW2ij9nzVdVrynFWfK9ODNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHcCpRV1h3/VjFGgRQxSnpDN1a8P2Cy8/vOdAREUDzf9d1o91qX8noQWuR13XZfkWqXm9rEYJkHwSRaq6giddl3TXEA1t4XxWn9H0hV+ganffTsRmzNuQpqhy8fSJjPuskpAAFvphBxuAsRDfkXXqZuGZ7l+KEeW9gn6TLwpWhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4VqTo2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4VqTo2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3E9C4CEC7;
	Mon, 14 Oct 2024 15:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918982;
	bh=xpzQWfvHAiZRzq5Xz1ZScW2ij9nzVdVrynFWfK9ODNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4VqTo2tiY0h4qRllCF1AMmVYF0XuyROMsuyXfQPJiZTAzTGDg2yIkbJWx9ppn4XV
	 1ajsfWXrXCm1ucIf7KcoQ04jrB7/qKGVi6fkV9JswaNTeVKc7s1kMPf4uPpd8KLNse
	 9qq7PAb+C15XFCe7OmyXQLG0e9bQ9Ufx9D4q0eVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 462/798] ALSA: asihpi: Fix potential OOB array access
Date: Mon, 14 Oct 2024 16:16:56 +0200
Message-ID: <20241014141236.124406327@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7b986c7430a6bb68d523dac7bfc74cbd5b44ef96 ]

ASIHPI driver stores some values in the static array upon a response
from the driver, and its index depends on the firmware.  We shouldn't
trust it blindly.

This patch adds a sanity check of the array index to fit in the array
size.

Link: https://patch.msgid.link/20240808091454.30846-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpimsgx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/asihpi/hpimsgx.c b/sound/pci/asihpi/hpimsgx.c
index d0caef2994818..b68e6bfbbfbab 100644
--- a/sound/pci/asihpi/hpimsgx.c
+++ b/sound/pci/asihpi/hpimsgx.c
@@ -708,7 +708,7 @@ static u16 HPIMSGX__init(struct hpi_message *phm,
 		phr->error = HPI_ERROR_PROCESSING_MESSAGE;
 		return phr->error;
 	}
-	if (hr.error == 0) {
+	if (hr.error == 0 && hr.u.s.adapter_index < HPI_MAX_ADAPTERS) {
 		/* the adapter was created successfully
 		   save the mapping for future use */
 		hpi_entry_points[hr.u.s.adapter_index] = entry_point_func;
-- 
2.43.0



