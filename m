Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD97A377A89;
	Thu, 20 Aug 2026 15:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239383; cv=none; b=leKMIkfzZrtW6clVd65RfjeaiBK0+CKzd98DtExjK+hlFjwUUVJcilFIQN9QItSGaVGA0/y0WAR5i4m6QZdQEznDDuNc1K4bwNyZUmgV2Ei70qcFH3wQQFerCdfbZYgzHjsQz5kHIcrqe+e7zf9XXJY+MY7vKraIofVVNjch06Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239383; c=relaxed/simple;
	bh=IFYe170cAdiNq8Mpddbw3C3vDbVzsI4BQeMEU0Gf2mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAjP42PJtoGj/MEBilso83+b1DfQRqmmCoB9i+lTKsfRbiXnFIiSRYIEexBXghEjCr3ajFl0YsClRO/H7p8ezR8JqkUh1Wrbccd2aHQW4hvPAQqalc1V17KJhwl3dO9DskcqPzBcJ3s1d3jr03cFIJgcJPdXqsmxANvql7BiwCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLLNiZcH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLLNiZcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A311F000E9;
	Thu, 20 Aug 2026 15:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239382;
	bh=3iVJ+fs16pP4B4bRVe/i0bXUtOpeDxz2ixurjME1BbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLLNiZcHefC9sn6y8TJJEIcoHfweaHkFr9emVVOrfq6pwAVoJ/zKA9fmkrJfAIYpn
	 TovM/zMdDK2OzDQJcsytvG5pzIbUMZ2sARWG1wht2iFf2EUVnafy1BhldI7Tmc0v4I
	 IQ/5MW72H0N4KTgNoIsh0Yjo9GKaBs0OquvXM81s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.12 031/220] drm/panthor: skip zero-sized firmware sections
Date: Thu, 20 Aug 2026 16:53:41 +0200
Message-ID: <20260820145224.434293300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 2b8f13d3c7e26c46c20d9e367904cf01729c88e6 upstream.

panthor_fw_load_section_entry() skips BO creation when the firmware section
VA range is empty. If such a section is added to the firmware section list,
section->mem is left as NULL.

Later reload and unplug paths iterate over all firmware sections and
dereference section->mem, which can lead to a NULL pointer dereference.

Zero-sized firmware sections are valid, so accept them as no-op entries but
skip adding them to the section list.

Fixes: 2718d91816ee ("drm/panthor: Add the FW logical block")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20260724172621.63046-1-osama.abdelkader@gmail.com
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -549,6 +549,9 @@ static int panthor_fw_load_section_entry
 		return -EINVAL;
 	}
 
+	if (!section_size)
+		return 0;
+
 	name_len = iter->size - iter->offset;
 
 	section = drmm_kzalloc(&ptdev->base, sizeof(*section), GFP_KERNEL);


