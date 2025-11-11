Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA305335081;
	Tue, 11 Nov 2025 01:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823486; cv=none; b=DPEGuOh8wN9YqZXKXq01DMFCDM0KKwJ5qenMZ3M50AUnc4+aqWS0yOomoR6ycM0c9PyJ3hujq3Xr9wHoSz+5lC2CwGRMzrq7loOm4qD0HnwQc5LaLx5JnaYZ/XVWRm8OO78SORHK3o4wdM723MH3BQfqVl5aJham0dRNzpGuQmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823486; c=relaxed/simple;
	bh=+oJdBj1vSf6WXPZcipb0aqE9AvqN3LW2gBZkN6kGtcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kn+gyF0hd54SW6VCIQ3eAt9wBvwPt+ufIsfK2TfHpJXZLGq7r+rhBWFl4zrom6BHU3q/+DQiNLfpaWX1VrSeSDN2AnSgFJTP18OgpTytBofXyk4pC4Pyg5xAS04S131fVHHHRFtjAfzkjH1u1aZ/eYHKVzysqtHNpzG3XFHLRBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tAolOegq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tAolOegq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EA4C4CEF5;
	Tue, 11 Nov 2025 01:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823486;
	bh=+oJdBj1vSf6WXPZcipb0aqE9AvqN3LW2gBZkN6kGtcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAolOegqNBSgQjji8LJB1y/9QJtmQW4WNgc3Smhb9r4rCUvFdLAXRStErUpmrl0Gf
	 hniI6ANNMExvP9b7EEzm+w8kWyR7pfBsuyMANECk1T8OlxfaCQCXwjRe9aeaippUdp
	 7CiPbOsHAPD5WxXXGfz6zqsPG5BhyiaGjYfTHOCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 256/565] drm/amdgpu: Correct the counts of nr_banks and nr_errors
Date: Tue, 11 Nov 2025 09:41:52 +0900
Message-ID: <20251111004532.660504912@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ce Sun <cesun102@amd.com>

[ Upstream commit 907813e5d7cadfeafab12467d748705a5309efb0 ]

Correct the counts of nr_banks and nr_errors

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
index a95f45d063144..a7ecc33ddf223 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
@@ -86,6 +86,7 @@ static void aca_banks_release(struct aca_banks *banks)
 	list_for_each_entry_safe(node, tmp, &banks->list, node) {
 		list_del(&node->node);
 		kvfree(node);
+		banks->nr_banks--;
 	}
 }
 
@@ -236,6 +237,7 @@ static struct aca_bank_error *new_bank_error(struct aca_error *aerr, struct aca_
 
 	mutex_lock(&aerr->lock);
 	list_add_tail(&bank_error->node, &aerr->list);
+	aerr->nr_errors++;
 	mutex_unlock(&aerr->lock);
 
 	return bank_error;
-- 
2.51.0



