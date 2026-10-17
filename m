Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2042D73A6;
	Sat, 17 Oct 2026 16:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255600; cv=none; b=IerXgHnnyhQHE/wceEcn9rvG7JOyVarypJxc7ZZCUfHhr6MQIU27Jsxay8Tj1uoG8N7E/ShZ4TCuevro+ogPAZ/DBxXXZOaIHkwg0qEf0ukpoUkijdtWJAl+mNAHzVc6Z74By/FVMQvrXLnFU6GxCvlHxWbnQHHjjbXiE8uoPQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255600; c=relaxed/simple;
	bh=aAcE8opHTafPyrZeLQ8qdmNcYM++JEpY3UdA+ll+0AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCtoF3HbkV7DlmhSo7hKoAzJAbHWQ12ZCdJaYUcmZlYITLcRtrDeSC4UDa0kKbA+YcAQJ9SPlrmoTtOlx35UuTxbJ3J9+r6+i6woOyYTr0GDtZG8Tp9YHcuDP36PvFJsZRZdaQLPb9Dak7TN9fgZSXGhr/yNJjOdDxhp3Txh17A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtu+iQlJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtu+iQlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839A51F000C4;
	Sat, 17 Oct 2026 16:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255599;
	bh=h4OOi+jM4ma7I/vBpce/Q1zoWG3vHblaRo5s/oReZ5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mtu+iQlJmux6wcUO0GVTAml+lZLXxov92rfeg52rF1LkgS+lQBHEtLg5xVmI+r4sw
	 Q5iAWG7jWIx8jPJhVXVw+/mpc5vHEu0Ssjww6xRnNJVY6PNnV7wo1W6aGl1guwNl3S
	 yFWsgp4G3AhjOL+QixCDmPkuUx0GF6KXqWZrIsyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 828/869] s390/kvm: Mask extra bits from program interrupt code
Date: Sat, 17 Oct 2026 18:01:09 +0200
Message-ID: <20261017160058.110193173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 34fb045eddd300a2d1c0d7de7e83113215c422e3 ]

The program interrupt code has some extra bits that are sometimes set
by hardware for various reasons; those bits should be ignored when the
program interrupt number is needed for interrupt handling.

Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20241031120316.25462-1-imbrenda@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 2 +-
 arch/s390/kvm/vsie.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c11e579e23313..7bb5640bb8a71 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4847,7 +4847,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	if (kvm_s390_cur_gmap_fault_is_write())
 		foll = FOLL_WRITE;
 
-	switch (current->thread.gmap_int_code) {
+	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {
 	case 0:
 		vcpu->stat.exit_null++;
 		break;
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 44e25b2654a2d..de9f0dd421979 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -923,7 +923,7 @@ static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
 	int rc;
 
-	if (current->thread.gmap_int_code == PGM_PROTECTION)
+	if ((current->thread.gmap_int_code & PGM_INT_CODE_MASK) == PGM_PROTECTION)
 		/* we can directly forward all protection exceptions */
 		return inject_fault(vcpu, PGM_PROTECTION,
 				    current->thread.gmap_teid.addr * PAGE_SIZE, 1);
-- 
2.53.0



