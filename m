Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6714A8430;
	Wed, 30 Sep 2026 17:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788703; cv=none; b=GHjQJyHtuaS1N08l+Os2BJWOxS30rrC/KGRWgtsb+fQKLu10wbGQv5Cvx+mGJSAJp2yz0ejK5lBH+FhZhtq/mN4c/R5S3pwgnz51RMHPwocZngWyV+vjltzpF3vy1lx+/UX6HPrDZm2KnG2IqwHv95LG6COsvPmBJBqcPJ43BZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788703; c=relaxed/simple;
	bh=L/816UHmgSVQYys2NBJD5EkpcNC9FnyRlNjrcE3bHSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAJ9qtNnFdIWrJbsnllDghqo4xQ04wJ2I1Qt7NoXmcKMFt8N8/gqyohB3boDuBVUxHSX4l3m93AIrbUafD8gKL7/TBz6OlHS3o7XhaptjW4hV8x6e13WzLMvQsj18AxzvNNlZ31773fxSLc1mn5LP5537Kk65nBezvm8OWldins=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbMpfH+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbMpfH+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9391F000FF;
	Wed, 30 Sep 2026 17:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788702;
	bh=rYFZIenygcr/bZdkpWGkcEkHrvDr1ETm5c2h2yWomkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bbMpfH+rQ731UscNa3aiRkvnscGQr1i/W+tFhIwmLIWBGZy6OO0qXrjczcAgOFIB/
	 NqqsqVm+GL0Zi0Bt5lXsfzwcoZ4QJIiXgoV627ngwFrM/DsPV9ByPtIs6qz7ijc9pp
	 lM0QBI5KX618xjIOD2SKWZgn77JdE0Bphtemb18g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.12 219/877] power: sequencing: fix NULL-pointer dereference in pwrseq_unit_new()
Date: Wed, 30 Sep 2026 17:18:50 +0200
Message-ID: <20260930152419.454008584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 115b303e8e093d964089ec6f3c40d984d77b33d0 upstream.

If memory allocation fails in pwrseq_unit_setup_deps(), pwrseq_unit_put()
is called to release the partially initialized unit. However, we've
never initialized unit->list and pwrseq_unit_release() will
unconditionally call list_del() on it. Initialize unit->list right after
allocating the unit struct.

Fixes: 249ebf3f65f8 ("power: sequencing: implement the pwrseq core")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260903-pwrseq-kunit-v1-0-1f893d2cabc2%40oss.qualcomm.com?part=1
Link: https://patch.msgid.link/20260909-pwrseq-kunit-v2-2-ef496afc89d2@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/sequencing/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/power/sequencing/core.c
+++ b/drivers/power/sequencing/core.c
@@ -101,6 +101,7 @@ static struct pwrseq_unit *pwrseq_unit_n
 	}
 
 	kref_init(&unit->ref);
+	INIT_LIST_HEAD(&unit->list);
 	INIT_LIST_HEAD(&unit->deps);
 	unit->enable = data->enable;
 	unit->disable = data->disable;


