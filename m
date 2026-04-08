Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DB32727F3;
	Wed,  8 Apr 2026 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674239; cv=none; b=Eoxl0VJEYzEe1CZlHqHbbfjwqjJDvK7JcBQ/Imr+ZKH3AwLGZLUe5hZl0s/lgA/ciR2LnzMn8eqRjWa8gJabY5zKg+OMbddVIyREFEPQ5/sK7nFHj6mMLTc2HvFZwIUMvUJlpixL2iSOrbzC7XZF+r1TWv5SX3sGvKpBeEHMJxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674239; c=relaxed/simple;
	bh=/jgtYzdH71Ex1+O9SBRDBfk/n5lsiUHYxtCRyYCJ1T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZebgOUYBKeLWupOlmUUK6zGO8Mz3ugzT2y5tN28Cg44CHFvc52s4O+UITnUvxrde/MQzFAOyAuTRP0uOsbPYHv6vjYrQ4uWcVz2Etx6heNMlG2dbc21ZaumDk8bNVfNpldWc8NSWYUDyLa5taYR4pV4bHoTC+zRjCNJOKxA9fTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDNJUIce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDNJUIce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34202C19421;
	Wed,  8 Apr 2026 18:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674239;
	bh=/jgtYzdH71Ex1+O9SBRDBfk/n5lsiUHYxtCRyYCJ1T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDNJUIce7m1cdQRyHEKxpjyZ6JI3jNxWGRGlOe3z9Sfn92vlQ1TxEGh4z0YHNk0Fq
	 Um9hKWJEpQO8wlxesIUZtNKrPBXR811cmcsooBGfR+Al2ln/bKp4vvS8f8PLH1maHI
	 sYTtSTVT/S0rEaoiadrjNGNCCd7XhnVc6NEDBMaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 020/311] HID: multitouch: Check to ensure report responses match the request
Date: Wed,  8 Apr 2026 20:00:20 +0200
Message-ID: <20260408175940.168322288@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit e716edafedad4952fe3a4a273d2e039a84e8681a ]

It is possible for a malicious (or clumsy) device to respond to a
specific report's feature request using a completely different report
ID.  This can cause confusion in the HID core resulting in nasty
side-effects such as OOB writes.

Add a check to ensure that the report ID in the response, matches the
one that was requested.  If it doesn't, omit reporting the raw event and
return early.

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index b8a748bbf0fd8..e82a3c4e5b44e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -526,12 +526,19 @@ static void mt_get_feature(struct hid_device *hdev, struct hid_report *report)
 		dev_warn(&hdev->dev, "failed to fetch feature %d\n",
 			 report->id);
 	} else {
+		/* The report ID in the request and the response should match */
+		if (report->id != buf[0]) {
+			hid_err(hdev, "Returned feature report did not match the request\n");
+			goto free;
+		}
+
 		ret = hid_report_raw_event(hdev, HID_FEATURE_REPORT, buf,
 					   size, 0);
 		if (ret)
 			dev_warn(&hdev->dev, "failed to report feature\n");
 	}
 
+free:
 	kfree(buf);
 }
 
-- 
2.53.0



