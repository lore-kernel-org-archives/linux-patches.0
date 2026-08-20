Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E5B360745;
	Thu, 20 Aug 2026 15:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238743; cv=none; b=BBFDcUe9dhgl0DZqNao+qsWUT7L4VPPd3bzLwGQhmPy0hmcURK6r82kNT2OGWLrtUD8NjW2OL1epc6kGTgib3/txVgy01h1jZkHvQfon+bl36P0SC5Zs6qqTIenE+uIYm4RVNqKQw3cA2Aa1h/2+SiZ5Y4Cd9HOqKixWMLcNYPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238743; c=relaxed/simple;
	bh=zArGgR2A0RKYQlZenK+CRWZ4M1hD4ZEYS28C4bqSDxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHa3LA8DM8WoqUXsEoagoDrBpgJ1bXb0O19LeG3+KsSlfCH8vNSoJhh6deU3sY3gTP3D+fh4c13ptwOeyqyozcdqC2hFZ3O7Ilst+2HuKh6bLH/x6swt0WUL0+vGIHNbiJfJhJSjvnUOqSuq8IIg0lFa6FrRmHV+OXYCJ2TXv+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8Y8iRdK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8Y8iRdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4701F00A3D;
	Thu, 20 Aug 2026 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238742;
	bh=+9XfCGFUgdhOowD4rjPLqVColRWPa/eGVBTPW0gzXsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8Y8iRdK+knywfw0ezySDnv0UkJpH/aDvBDWLGgg1muBtmtUF9458FFsktZDdymlH
	 RvXAWUiQMJwgK9xFcE9Mk+t+M9Y/XviCGoPHXRHoymcpYsfqH5pTO8d0WvA5nzhGeb
	 lHOQPJ08oMcCESHo8SQRO4E/r3ZEJhKczjUOphZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.18 025/217] drm/panthor: skip zero-sized firmware sections
Date: Thu, 20 Aug 2026 16:53:13 +0200
Message-ID: <20260820145238.378044792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
@@ -553,6 +553,9 @@ static int panthor_fw_load_section_entry
 		return -EINVAL;
 	}
 
+	if (!section_size)
+		return 0;
+
 	name_len = iter->size - iter->offset;
 
 	section = drmm_kzalloc(&ptdev->base, sizeof(*section), GFP_KERNEL);


