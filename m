Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A646943302F;
	Tue, 21 Jul 2026 19:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663941; cv=none; b=kDR7rKu9xWh+o6JV/lacfCNIx+aTsaQdQgP3n567FrINhwGh2JyiYjNBJit9CE6rH40y5b6uDL0/jJUKJ42X+LZWKL2k/MZKPDGfadW7rJl2AcEGO6R+CyB9ITI6jHuhRZw69Vhi5iL55St2+iICgfExqepDaJVVaiiVujayTuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663941; c=relaxed/simple;
	bh=nB+kBm/JSaLF3LFH9otbPQTP1uYsIkc7WapOL96idgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X97VLtQayAgr1ucxKuVj9tQu5pg4baVqupqRZbXf0RA74PiEEzcYQB30fXLt6Oh+sPhmJutESsO0V4rJqtwh/mEgPYh0a7vQTOo+ktR1+kVr4108VL2xky5Tzb/+/V+lf2s3DmHbfdU+iFlcgRedM+Dx1slgAi0HMTH7j6YvdHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bk9Ar3gU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bk9Ar3gU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184991F000E9;
	Tue, 21 Jul 2026 19:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663940;
	bh=mBpwud7WRVypvHYeqFvQb+w0yc2cyLsuPUNdGyWfHhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bk9Ar3gUj0tHonCVEEUvWBINl89KmKftbYjjGqM1wGF7bnKqhmpAKD62SmAo3Jv90
	 60i56PP4qYzeQqLDyFDMZtZlJMOEkxL2WblkdkN7xjPWyxxyKqaBI9ta+QUTtVlgIW
	 Nxm4wY+aIl1i7tWmXTls0qs+jC5JjPnk9p3JrIwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 1011/1276] dm-verity: avoid double increment of &use_bh_wq_enabled
Date: Tue, 21 Jul 2026 17:24:14 +0200
Message-ID: <20260721152508.629480270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -1238,6 +1238,8 @@ static int verity_parse_opt_args(struct
 			continue;
 
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_TASKLET_VERIFY)) {
+			if (v->use_bh_wq)
+				continue;
 			v->use_bh_wq = true;
 			static_branch_inc(&use_bh_wq_enabled);
 			continue;


