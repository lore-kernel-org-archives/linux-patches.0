Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128222C0F97;
	Wed, 25 Feb 2026 06:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002561; cv=none; b=tHFXdyCqKuo6yomVpyWH580/QRQuWb3ATRSbvtTfx9cEzcif9qrzArge9ExWtJRIwFAlCD4O0tYXq9AgtpFRppYRfmpW/mHvhS6TLmus8/StUl1dtjbii4HmoQmh2Uakt3UVVuKOng/vl0tehyv6IMYHzX/1wbvj9Hrm6NbXWnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002561; c=relaxed/simple;
	bh=UOQqNHOOzi/S7975CQI43HRnTbXBTsQny+IyamDH9aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3UY6EO/oKt1k8wH/Z9B7U0XRLNy/Q3wqWoyXXbC91qki9xlWXkrFMmdElxc63SUJMmqpOMRsN/Xnwp5e0KLPOu37xqZSGruq4er7eL3UmD0l0mjow0LsS1+I/EtHAjKJZvHcapRJkjzE6m+U99dZ3/iQxwExo6sycJajgVodPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VclHQXF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VclHQXF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADCCDC116D0;
	Wed, 25 Feb 2026 06:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002560;
	bh=UOQqNHOOzi/S7975CQI43HRnTbXBTsQny+IyamDH9aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VclHQXF/cXwh2c6zqpS08SOfSQwVZOO/ujLc4e+137mQte0iqF8X2BPuoO7DXdd8Q
	 p2Ps+WsnZVMEQwgu5sfWJxIxGtxlf5epIxKgSkrodZ0qmkqZu+ULiwaDvKylchO+5S
	 EN6vmMuOMbR4wm/vX95wrO1tVdf28R06aXSMKKhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tuo Li <islituo@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 297/641] of: unittest: fix possible null-pointer dereferences in of_unittest_property_copy()
Date: Tue, 24 Feb 2026 17:20:23 -0800
Message-ID: <20260225012355.943871531@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tuo Li <islituo@gmail.com>

[ Upstream commit d289cb7fcefe41a54d8f9c6d0e0947f5f82b15c6 ]

This function first duplicates p1 and p2 into new, and then checks whether
the duplication succeeds. However, if the duplication fails (e.g.,
kzalloc() returns NULL in __of_prop_dup()), new will be NULL but is still
dereferenced in __of_prop_free(). To ensure that the unit test continues to
run even when duplication fails, add a NULL check before calling
__of_prop_free().

Fixes: 1c5e3d9bf33b ("of: Add a helper to free property struct")
Signed-off-by: Tuo Li <islituo@gmail.com>
Link: https://patch.msgid.link/20260105071438.156186-1-islituo@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 3b773aaf9d050..9c184e93f50c6 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -804,11 +804,13 @@ static void __init of_unittest_property_copy(void)
 
 	new = __of_prop_dup(&p1, GFP_KERNEL);
 	unittest(new && propcmp(&p1, new), "empty property didn't copy correctly\n");
-	__of_prop_free(new);
+	if (new)
+		__of_prop_free(new);
 
 	new = __of_prop_dup(&p2, GFP_KERNEL);
 	unittest(new && propcmp(&p2, new), "non-empty property didn't copy correctly\n");
-	__of_prop_free(new);
+	if (new)
+		__of_prop_free(new);
 #endif
 }
 
-- 
2.51.0



