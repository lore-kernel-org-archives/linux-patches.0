Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21173B0ACB;
	Mon, 23 Mar 2026 14:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274739; cv=none; b=snQWwL6AdEh07I9WC/4DK52L2er/RPz4oeE15Q90AwhgEyfQeVPrO+pV7uZeLaHiUZGsfG4alnao+Zz/RkVBAuCkJvUZYwB6SN5MyPj4Xga9csBni+VZwEAeuyeks0e3HAsaz08FLbQhx0+1Ftkq2jPbb0kbm8Url2OnIHPqHbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274739; c=relaxed/simple;
	bh=JZ4eR8diKEBgV1BckWVhCmfRqXODaVcSNNW0Z69m5fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBLwLcvL4YCl35MI+7vAXviFRQqmkcZ/JE7N9x3gL7COqsoWOzJDbW/gqxy/cb0jlpKMzFp/MQUmqDIw7MsxD91k0S/oFvVBq8ZsZFnHxBpJs8bCDQVkUKCl2JlRMjRvei9m+j87bIT3GHXF9EfM3Yvel11oyqfoQzr2Axp8W4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=esNGEUN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="esNGEUN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26288C4CEF7;
	Mon, 23 Mar 2026 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274739;
	bh=JZ4eR8diKEBgV1BckWVhCmfRqXODaVcSNNW0Z69m5fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=esNGEUN6hCWhoEZkQfxeUf+UmrL5ltKcoQt3dpF6a3+A3sf87YtC0yZpEISVqkH9c
	 9w8zLhddIhzUpM6dXND7JZjFHLH61ItFPJKssMRJt8Rq7J1AcNl1DB/h0t7ZQj+g5x
	 ui983E+mRVcnDH0H1LfjWT0ZXyXwsRJB609Nulvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 094/212] drm/xe/guc: Ensure CT state transitions via STOP before DISABLED
Date: Mon, 23 Mar 2026 14:45:15 +0100
Message-ID: <20260323134506.748761296@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhanjun Dong <zhanjun.dong@intel.com>

commit 7838dd8367419e9fc43b79c038321cb3c04de2a2 upstream.

The GuC CT state transition requires moving to the STOP state before
entering the DISABLED state. Update the driver teardown sequence to make
the proper state machine transitions.

Fixes: ee4b32220a6b ("drm/xe/guc: Add devm release action to safely tear down CT")
Cc: stable@vger.kernel.org
Signed-off-by: Zhanjun Dong <zhanjun.dong@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260310225039.1320161-6-zhanjun.dong@intel.com
(cherry picked from commit dace8cb0032f57ea67c87b3b92ad73c89dd2db44)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -266,6 +266,7 @@ static void guc_action_disable_ct(void *
 {
 	struct xe_guc_ct *ct = arg;
 
+	xe_guc_ct_stop(ct);
 	guc_ct_change_state(ct, XE_GUC_CT_STATE_DISABLED);
 }
 


