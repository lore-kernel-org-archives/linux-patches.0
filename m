Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DF6403B06;
	Tue, 21 Jul 2026 17:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654840; cv=none; b=Pi6u14tD4h77efYbQs/l+sXotmJ3Pml+nNSsMABRz2SAH9uAI7Ug0Nz3p4sdtNJSCi0Aj1crt0VvYqvrlVLXfjIeHkJrg0TN7gnXqYA03Dar5nPHyYT3/IzC1T/dgp/nWYhJaDWC9w14YqVJenumkfOaD/plU8vQZ+NInnk7s5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654840; c=relaxed/simple;
	bh=arJqiLIatxxhogsNdcC0hh+iIG/B+kmJ26uZFYfDjdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rW8Y28aBT1sAHf/cuxw6f5kHG3VtGnWVTfK3GZDCKWlapR9TQig6Sb8SsW8BHgicMM14xQSxvLd5qCo2ogHsGlslPLystgKh6ABxLiNQi+NeY/hyOfMjH9WAaRilZjNmq81ei+Ul+mh0NJyMiNKC2kVqojaCgtkD+lY17wcsbNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIagLoSm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIagLoSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638B41F000E9;
	Tue, 21 Jul 2026 17:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654838;
	bh=9bp0xvE7aSkQb5epqCt4uBdUdGjfXcpfjiYLKaOGZcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIagLoSmR+4zXq765B0MwG1KJpHjHZ1eFvD4wd6MOkIlyYwaXU2mO0e05Zn3Xn/Ln
	 rRH8OvrZP9BRmFKZiez9bnNr/L7QHvB4YKJIozG1qJR6anLbq1EnQ/55gZ4oIogMam
	 7aSa1uspLetkOUpbaHMk0A566LO/GH59hW6rqbmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1858/2077] dm-verity: avoid double increment of &use_bh_wq_enabled
Date: Tue, 21 Jul 2026 17:25:31 +0200
Message-ID: <20260721152636.558890060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1262,6 +1262,8 @@ static int verity_parse_opt_args(struct
 			continue;
 
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_TASKLET_VERIFY)) {
+			if (v->use_bh_wq)
+				continue;
 			v->use_bh_wq = true;
 			static_branch_inc(&use_bh_wq_enabled);
 			continue;


