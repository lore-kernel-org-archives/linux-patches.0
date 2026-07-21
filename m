Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641E846EF66;
	Tue, 21 Jul 2026 18:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659004; cv=none; b=Nv9KUlhpD+CMT46d9NvNRZMTyiBWUsNVncAMxKU3LLaEoXL0qAoTRr5FqNuXCIUeKJAq2epeAT/OtMhycznF7jtKcRN+r/SVaSs2OxYGO/FANginrhjGN5bB0JgwsyjZc9BSEP+scgsz4hzCNm8f/pSU/6mvSAP1u2uua7yAhqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659004; c=relaxed/simple;
	bh=jBZO+URcKk6RGU8FJOICkKodmM4HAr5gkFVwG+2TRpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRJyV/W8neLzAW2oOygq+YszIhLjUbL6JNwj44EQerXNhufeChOTAbs4fZBfT6I39iM9U/1FY95qVEOsrWBBcRS4M/13xITLoISpwhfpF5r1BKmXvXKJXc1mfiIekYjXEu90n5wamzhDkirNBS2HcrxRd5iY2RIQzTn4xVsx+fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5G/Cjim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5G/Cjim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C768D1F000E9;
	Tue, 21 Jul 2026 18:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659003;
	bh=ydeqGdtJwZtXDQFYUm7RakgyXtbfBb9OMyYty3hd8/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5G/Cjim8Uhco3vu6+Lf76/DxZu0q/hU+YdOqrDyB+3xcf9SFV66uo769qWu0NeGA
	 IUIaDb7uAniAH95NP4KbN+ORMiF9xWzYcf5/9ZvoQZaSA1nX2JODthBk95qFB4ok6D
	 lvC5RA+kvFr7uux3DoZ2VTC0ZHIK0YUBIggJ3dBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1358/1611] dm-verity: avoid double increment of &use_bh_wq_enabled
Date: Tue, 21 Jul 2026 17:24:34 +0200
Message-ID: <20260721152546.000489860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 72e9ec2fe32b00994f41719cf77423fca67d48b2 upstream.

verity_parse_opt_args is called twice, first with the only_modifier_opts,
first with only_modifier_opts == true and then with only_modifier_opts ==
false. Thus, the static branch &use_bh_wq_enabled was incremented twice
and the destructor verity_dtr would only decrement it once.

Fix tihs bug by only incrementing it on the first call, on the second
call, when v->use_bh_wq is true, do nothing.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Cc: stable@vger.kernel.org
Fixes: df326e7a0699 ("dm verity: allow optional args to alter primary args handling")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1194,6 +1194,8 @@ static int verity_parse_opt_args(struct
 			continue;
 
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_TASKLET_VERIFY)) {
+			if (v->use_bh_wq)
+				continue;
 			v->use_bh_wq = true;
 			static_branch_inc(&use_bh_wq_enabled);
 			continue;


