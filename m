Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626EA611A
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 14:26:14 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 4-20020a251904000000b00b7f75c3cafdso40568717ybz.16
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 07:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681309573; x=1683901573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WJTQsHGephiRRGvzWHKa1YfmC5Q/3ge7v2DAEPqx4c4=;
        b=V7YEThzOYtDMs86dvZiALvp5IGI1ltp4+kzxus8hjvBQgA+Hkeig7HSUu4Xtw0ABuT
         VtTwZFgtMVgH4L2D0wF2tEbs6UGd3gWATRDmagm0lL/Hssv8vHVfEzed0WE9fbFcHJj0
         v/rxKWTHDNKWV65IkKtCw9KqWHM1YSyzqwP9hQ1NpOyTUIENXwC+/maq9qX4yZgzy9My
         YFgmroTeA6XHPnOg3ibWPnvpGMauSXEa67Fk1HfkD5XdI53DjHrX7XY9GHcxCsgJc232
         v5gVo1gtg6/x4MP1vh004GqLXaHM2nuIkfQSpveSpJ4WZEYnIA5NPXedU5zpR5AQ19DU
         Oeew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681309573; x=1683901573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WJTQsHGephiRRGvzWHKa1YfmC5Q/3ge7v2DAEPqx4c4=;
        b=bbJv3HCegWRRnnIpd9ltTPTo2y7FYs0vp6/OmMCLDQcrKTK/jdjITNLooRpgXfIGUK
         OozlHDz1Bo1TJkquHDuDaTWYfR1fcnc4GFysxhSLD3S54ZsokYkUUtkRLET6UhqRrZ1u
         XX545pMNbK3XU/I0gqbaRCV10OLN5v4Ipg7nBVJg1VgEfeY4kgLNpWg/ApY457InUti8
         xCkzqpHxKPqH9bAp41B1Utveg7IFvcFDccVfuk8o66RN5piXOgnR8ep859vMepFKaLQD
         U55+4C3b+wndh8zWq0SAAqoJJdKEzPDZzm0MnK9F3UedPOQguSQIf95K5TkN8EBYY6PX
         BrYg==
X-Gm-Message-State: AAQBX9dFGd2a/P/wd47CHIWNhZ0FR7uRHATh52a0x/WRUk7125gqHPtY
	BCwqSrw+kPjxyM4ZtUqGmkuhzb++Mio=
X-Google-Smtp-Source: AKy350Zl6YR9aOMGTUQskmFoZx6nvL9NvZh8zC6FVTwxZ9uu9+IB2T122NWVpTOkYAsoDGf+KrZU/SFr+1U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7654:0:b0:b8e:e0db:5b9d with SMTP id
 r81-20020a257654000000b00b8ee0db5b9dmr6098435ybc.12.1681309573433; Wed, 12
 Apr 2023 07:26:13 -0700 (PDT)
Date: Wed, 12 Apr 2023 07:26:11 -0700
In-Reply-To: <87jzyhfnza.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230412082838.125271466@linuxfoundation.org> <20230412082842.164450040@linuxfoundation.org>
 <87jzyhfnza.fsf@redhat.com>
Message-ID: <ZDa/D5+HjGVuJgdA@google.com>
Subject: Re: [PATCH 6.2 101/173] KVM: SVM: Flush Hyper-V TLB when required
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>, patches@lists.linux.dev, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Apr 12, 2023, Vitaly Kuznetsov wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> >
> > commit e5c972c1fadacc858b6a564d056f177275238040 upstream.
> >
> > The Hyper-V "EnlightenedNptTlb" enlightenment is always enabled when KVM
> > is running on top of Hyper-V and Hyper-V exposes support for it (which
> > is always). On AMD CPUs this enlightenment results in ASID invalidations
> > not flushing TLB entries derived from the NPT. To force the underlying
> > (L0) hypervisor to rebuild its shadow page tables, an explicit hypercall
> > is needed.
> >
> > The original KVM implementation of Hyper-V's "EnlightenedNptTlb" on SVM
> > only added remote TLB flush hooks. This worked out fine for a while, as
> > sufficient remote TLB flushes where being issued in KVM to mask the
> > problem. Since v5.17, changes in the TDP code reduced the number of
> > flushes and the out-of-sync TLB prevents guests from booting
> > successfully.
> >
> > Split svm_flush_tlb_current() into separate callbacks for the 3 cases
> > (guest/all/current), and issue the required Hyper-V hypercall when a
> > Hyper-V TLB flush is needed. The most important case where the TLB flush
> > was missing is when loading a new PGD, which is followed by what is now
> > svm_flush_tlb_current().
> >
> > Cc: stable@vger.kernel.org # v5.17+
> > Fixes: 1e0c7d40758b ("KVM: SVM: hyper-v: Remote TLB flush for SVM")
> > Link: https://lore.kernel.org/lkml/43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com/
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Message-Id: <20230324145233.4585-1-jpiotrowski@linux.microsoft.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> It seems issues are still observed even with this fix, right?:
> https://lore.kernel.org/kvm/959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com/

There are no functional issues with the fix, and there's no evidence that KVM is
to blame for the slow L2 boot times when the TDP MMU is enabled.

> Jeremi, Sean, do you thing it's still worth it to push this to stable@?
> IMO a small patch disabling TDP MMU on Hyper-V would be better for the
> time being...

Yes, I think it's worth pushing to stable.  The fix is valid even if we end up
disabling the TDP MMU on Hyper-V as a workaround.  And the fix is mandatory if/when
the TDP MMU is re-enabled, or if we root cause the boot problem sooner than later
and don't have to resort to disabling the TDP MMU.
